//
//  CourseRepositoryImpl.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

final class CourseRepositoryImpl: CourseRepository, @unchecked Sendable {
    private let api: CourseAPIClient
    private let cache: CourseCaching
    private let isOnline: @Sendable () -> Bool
    private var memory: [Course] = []
    private let lock = NSLock()

    init(
        api: CourseAPIClient,
        cache: CourseCaching,
        isOnline: @escaping @Sendable () -> Bool
    ) {
        self.api = api
        self.cache = cache
        self.isOnline = isOnline
        self.memory = cache.load() ?? []
    }

    func loadCourses(forceRefresh: Bool) async throws -> [Course] {
        if isOnline() {
            do {
                let dtos = try await api.fetchCourses()
                var mapped = dtos.map(CourseMapper.makeCourse)
                mapped = mergeProgress(from: currentMemory(), into: mapped)
                persist(mapped)
                return mapped
            } catch {
                if let cached = nonEmptyCache() {
                    return cached
                }
                throw AppError.apiFailure
            }
        }

        if let cached = nonEmptyCache() {
            return cached
        }
        throw AppError.noCachedData
    }

    func cachedCourses() -> [Course] {
        currentMemory()
    }

    func course(id: Int) -> Course? {
        currentMemory().first { $0.id == id }
    }

    func markLessonCompleted(courseID: Int, lessonID: Int) throws -> Course {
        lock.lock()
        defer { lock.unlock() }
        guard let index = memory.firstIndex(where: { $0.id == courseID }) else {
            throw AppError.courseNotFound
        }
        let updated = ProgressCalculator.applyingCompletion(to: memory[index], lessonID: lessonID)
        memory[index] = updated
        try cache.save(memory)
        return updated
    }

    private func persist(_ courses: [Course]) {
        lock.lock()
        memory = courses
        lock.unlock()
        try? cache.save(courses)
    }

    private func currentMemory() -> [Course] {
        lock.lock()
        defer { lock.unlock() }
        return memory
    }

    private func nonEmptyCache() -> [Course]? {
        var snapshot = currentMemory()
        if snapshot.isEmpty {
            snapshot = cache.load() ?? []
            if !snapshot.isEmpty {
                persist(snapshot)
            }
        }
        return snapshot.isEmpty ? nil : snapshot
    }

    /// Keep locally completed lessons when the mock API is fetched again.
    private func mergeProgress(from cached: [Course], into fresh: [Course]) -> [Course] {
        let byID = Dictionary(uniqueKeysWithValues: cached.map { ($0.id, $0) })
        return fresh.map { course in
            guard let previous = byID[course.id] else { return course }
            var merged = course
            merged.lessons = course.lessons.map { lesson in
                guard let old = previous.lessons.first(where: { $0.id == lesson.id }) else { return lesson }
                var copy = lesson
                if old.status == .completed {
                    copy.status = .completed
                }
                return copy
            }
            let completed = merged.lessons.filter { $0.status == .completed }.count
            merged.progress = ProgressCalculator.percent(completed: completed, total: merged.lessons.count)
            return merged
        }
    }
}

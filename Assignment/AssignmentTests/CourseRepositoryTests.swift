//
//  CourseRepositoryTests.swift
//  AssignmentTests
//
//  Created by Kishorkumar on 07/10/26.
//

import XCTest
@testable import Assignment

final class CourseRepositoryTests: XCTestCase {
    func testOfflineLoadUsesCacheAfterSuccessfulFetch() async throws {
        let dto = CourseDTO(id: 1, title: "Python Programming", instructor: "John Smith", progress: 50, lessons: 4)
        let api = StubCourseAPI(result: .success([dto]))
        let cache = InMemoryCourseCache()
        let online = ThreadSafeFlag(true)
        let repository = CourseRepositoryImpl(api: api, cache: cache, isOnline: { online.get() })

        let first = try await repository.loadCourses(forceRefresh: false)
        XCTAssertEqual(first.count, 1)
        XCTAssertNotNil(cache.load())

        online.set(false)
        api.result = .failure(AppError.apiFailure)

        let offline = try await repository.loadCourses(forceRefresh: false)
        XCTAssertEqual(offline.first?.title, "Python Programming")
    }

    func testAPIFailureFallsBackToCache() async throws {
        let dto = CourseDTO(id: 2, title: "Generative AI", instructor: "Sarah Williams", progress: 40, lessons: 4)
        let api = StubCourseAPI(result: .success([dto]))
        let cache = InMemoryCourseCache()
        let repository = CourseRepositoryImpl(api: api, cache: cache, isOnline: { true })

        _ = try await repository.loadCourses(forceRefresh: false)
        api.result = .failure(AppError.apiFailure)

        let fallback = try await repository.loadCourses(forceRefresh: true)
        XCTAssertEqual(fallback.first?.id, 2)
    }
}

final class InMemoryCourseCache: CourseCaching, @unchecked Sendable {
    private var stored: [Course]?

    func save(_ courses: [Course]) throws {
        stored = courses
    }

    func load() -> [Course]? {
        stored
    }

    func clear() {
        stored = nil
    }
}

final class StubCourseAPI: CourseAPIClient, @unchecked Sendable {
    var result: Result<[CourseDTO], Error>

    init(result: Result<[CourseDTO], Error>) {
        self.result = result
    }

    func fetchCourses() async throws -> [CourseDTO] {
        try result.get()
    }
}


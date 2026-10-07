//
//  CourseDashboardViewModel.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

@MainActor
@Observable
final class CourseDashboardViewModel {
    var state: LoadState<[Course]> = .idle
    var isOffline = false

    private let repository: CourseRepository
    private let networkMonitor: NetworkMonitor

    init(repository: CourseRepository, networkMonitor: NetworkMonitor) {
        self.repository = repository
        self.networkMonitor = networkMonitor
    }

    func load(forceRefresh: Bool = false) async {
        isOffline = !networkMonitor.isOnline
        state = .loading
        do {
            let courses = try await repository.loadCourses(forceRefresh: forceRefresh)
            state = courses.isEmpty ? .empty : .success(courses)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            state = .failure(message)
        }
    }

    func syncOfflineFlag() {
        isOffline = !networkMonitor.isOnline
    }

    func applyCachedIfLoaded() {
        guard case .success = state else { return }
        let courses = repository.cachedCourses()
        state = courses.isEmpty ? .empty : .success(courses)
    }
}

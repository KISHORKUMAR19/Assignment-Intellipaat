//
//  AppDependencies.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

@MainActor
final class AppDependencies {
    let networkMonitor: NetworkMonitor
    let authRepository: AuthRepository
    let courseRepository: CourseRepository
    let session: AppSession

    init() {
        let monitor = NetworkMonitor()
        let onlineFlag = monitor.onlineFlag
        self.networkMonitor = monitor
        self.authRepository = AuthRepositoryImpl()
        self.courseRepository = CourseRepositoryImpl(
            api: MockCourseAPIClient(),
            cache: FileCourseCache(),
            isOnline: { onlineFlag.get() }
        )
        self.session = AppSession(isLoggedIn: authRepository.isLoggedIn)
    }
}

@MainActor
@Observable
final class AppSession {
    var isLoggedIn: Bool

    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}

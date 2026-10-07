//
//  AssignmentApp.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import SwiftUI
import SwiftData

@main
struct AssignmentApp: App {
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}

struct RootView: View {
    let dependencies: AppDependencies
    @State private var loginViewModel: LoginViewModel
    @State private var dashboardViewModel: CourseDashboardViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _loginViewModel = State(
            initialValue: LoginViewModel(
                authRepository: dependencies.authRepository,
                session: dependencies.session
            )
        )
        _dashboardViewModel = State(
            initialValue: CourseDashboardViewModel(
                repository: dependencies.courseRepository,
                networkMonitor: dependencies.networkMonitor
            )
        )
    }

    var body: some View {
        if dependencies.session.isLoggedIn {
            CourseDashboardView(
                viewModel: dashboardViewModel,
                dependencies: dependencies,
                onLogout: {
                    dependencies.authRepository.logout()
                    dependencies.session.isLoggedIn = false
                }
            )
        } else {
            LoginView(viewModel: loginViewModel)
        }
    }
}

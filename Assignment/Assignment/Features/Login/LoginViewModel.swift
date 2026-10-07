//
//  LoginViewModel.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    private let authRepository: AuthRepository
    private let session: AppSession

    init(authRepository: AuthRepository, session: AppSession) {
        self.authRepository = authRepository
        self.session = session
    }

    func login() async {
        errorMessage = nil
        do {
            try validate()
            isLoading = true
            try await authRepository.login(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            session.isLoggedIn = true
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    private func validate() throws {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.contains("@") || !trimmed.contains(".") {
            throw AppError.invalidEmail
        }
        if password.count < 6 {
            throw AppError.invalidPassword
        }
    }
}

//
//  AuthRepositoryImpl.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository, @unchecked Sendable {
    private let api: MockAuthAPIClient
    private let session: SessionStore

    init(api: MockAuthAPIClient = MockAuthAPIClient(), session: SessionStore = SessionStore()) {
        self.api = api
        self.session = session
    }

    var isLoggedIn: Bool { session.isLoggedIn }

    func login(email: String, password: String) async throws {
        try await api.login(email: email, password: password)
        session.isLoggedIn = true
    }

    func logout() {
        session.isLoggedIn = false
    }
}

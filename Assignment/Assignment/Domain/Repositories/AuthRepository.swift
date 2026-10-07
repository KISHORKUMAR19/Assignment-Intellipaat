//
//  AuthRepository.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

protocol AuthRepository: Sendable {
    func login(email: String, password: String) async throws
    func logout()
    var isLoggedIn: Bool { get }
}

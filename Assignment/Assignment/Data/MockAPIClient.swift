//
//  MockAPIClient.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

protocol CourseAPIClient: Sendable {
    func fetchCourses() async throws -> [CourseDTO]
}

struct MockCourseAPIClient: CourseAPIClient {
    var delayNanoseconds: UInt64 = 700_000_000
    var shouldFail = false
    var bundle: Bundle = .main

    func fetchCourses() async throws -> [CourseDTO] {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        if shouldFail {
            throw AppError.apiFailure
        }
        guard let url = bundle.url(forResource: "courses", withExtension: "json") else {
            throw AppError.apiFailure
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CourseDTO].self, from: data)
    }
}

struct MockAuthAPIClient: Sendable {
    var delayNanoseconds: UInt64 = 600_000_000

    func login(email: String, password: String) async throws {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        if email.lowercased() == "kishor@test.com" {
            throw AppError.loginFailed
        }
        _ = password
    }
}

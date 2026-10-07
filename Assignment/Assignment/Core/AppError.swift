//
//  AppError.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case invalidEmail
    case invalidPassword
    case loginFailed
    case networkUnavailable
    case apiFailure
    case noCachedData
    case courseNotFound

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Enter a valid email address."
        case .invalidPassword:
            return "Password must be at least 6 characters."
        case .loginFailed:
            return "Login failed. Check your credentials and try again."
        case .networkUnavailable:
            return "No internet connection."
        case .apiFailure:
            return "Could not load courses. Please try again."
        case .noCachedData:
            return "No saved courses yet. Connect to the internet and retry."
        case .courseNotFound:
            return "Course not found."
        }
    }
}

//
//  CourseDetailViewModel.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

@MainActor
@Observable
final class CourseDetailViewModel {
    var course: Course?
    var errorMessage: String?

    private let courseID: Int
    private let repository: CourseRepository

    init(courseID: Int, repository: CourseRepository) {
        self.courseID = courseID
        self.repository = repository
        self.course = repository.course(id: courseID)
        if course == nil {
            errorMessage = AppError.courseNotFound.errorDescription
        }
    }

    func markCompleted(_ lesson: Lesson) {
        guard lesson.status != .completed else { return }
        do {
            course = try repository.markLessonCompleted(courseID: courseID, lessonID: lesson.id)
            errorMessage = nil
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}

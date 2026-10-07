//
//  CourseRepository.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

protocol CourseRepository: Sendable {
    func loadCourses(forceRefresh: Bool) async throws -> [Course]
    func cachedCourses() -> [Course]
    func course(id: Int) -> Course?
    func markLessonCompleted(courseID: Int, lessonID: Int) throws -> Course
}


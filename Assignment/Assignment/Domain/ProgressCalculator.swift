//
//  ProgressCalculator.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

enum ProgressCalculator {
    static func percent(completed: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        let raw = (Double(completed) / Double(total)) * 100.0
        return Int(raw.rounded())
    }

    static func applyingCompletion(to course: Course, lessonID: Int) -> Course {
        var updated = course
        updated.lessons = course.lessons.map { lesson in
            guard lesson.id == lessonID else { return lesson }
            var copy = lesson
            copy.status = .completed
            return copy
        }
        let completed = updated.lessons.filter { $0.status == .completed }.count
        updated.progress = percent(completed: completed, total: updated.lessons.count)
        updated.lessonCount = updated.lessons.count
        return updated
    }
}

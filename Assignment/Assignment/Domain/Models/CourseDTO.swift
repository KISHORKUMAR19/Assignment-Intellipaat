//
//  CourseDTO.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

struct CourseDTO: Decodable, Equatable {
    let id: Int
    let title: String
    let instructor: String
    let progress: Int
    let lessons: Int
}

enum CourseMapper {
    static func makeCourse(from dto: CourseDTO) -> Course {
        let generated = LessonFactory.lessons(
            courseId: dto.id,
            total: dto.lessons,
            progressPercent: dto.progress
        )
        return Course(
            id: dto.id,
            title: dto.title,
            instructor: dto.instructor,
            progress: ProgressCalculator.percent(completed: generated.filter { $0.status == .completed }.count, total: generated.count),
            lessonCount: generated.count,
            lessons: generated
        )
    }
}

enum LessonFactory {
    static func lessons(courseId: Int, total: Int, progressPercent: Int) -> [Lesson] {
        let titles = defaultTitles(for: courseId)
        let count = max(total, 1)
        let completedCount = Int((Double(progressPercent) / 100.0 * Double(count)).rounded(.down))
            .clamped(to: 0...count)

        return (0..<count).map { index in
            let title: String
            if index < titles.count {
                title = titles[index]
            } else {
                title = "Lesson \(index + 1)"
            }
            return Lesson(
                id: courseId * 1000 + index + 1,
                title: title,
                status: index < completedCount ? .completed : .pending
            )
        }
    }

    private static func defaultTitles(for courseId: Int) -> [String] {
        switch courseId {
        case 1:
            return [
                "Introduction",
                "Variables & Data Types",
                "Functions",
                "OOP",
                "Modules",
                "Error Handling"
            ]
        case 2:
            return [
                "Introduction",
                "Prompt Engineering",
                "Model Types",
                "Fine-tuning Overview",
                "Evaluation"
            ]
        default:
            return [
                "Introduction",
                "Architecture",
                "Frontend",
                "Backend",
                "Databases"
            ]
        }
    }
}

private extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

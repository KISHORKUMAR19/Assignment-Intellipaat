//
//  ProgressCalculatorTests.swift
//  AssignmentTests
//
//  Created by Kishorkumar on 07/10/26.
//

import XCTest
@testable import Assignment

final class ProgressCalculatorTests: XCTestCase {
    func testPercentRoundsNearestWholeNumber() {
        XCTAssertEqual(ProgressCalculator.percent(completed: 0, total: 0), 0)
        XCTAssertEqual(ProgressCalculator.percent(completed: 1, total: 4), 25)
        XCTAssertEqual(ProgressCalculator.percent(completed: 2, total: 3), 67)
    }

    func testMarkingLessonCompletedUpdatesStatusAndProgress() {
        let course = Course(
            id: 1,
            title: "Python Programming",
            instructor: "John Smith",
            progress: 50,
            lessonCount: 4,
            lessons: [
                Lesson(id: 1, title: "Introduction", status: .completed),
                Lesson(id: 2, title: "Variables & Data Types", status: .completed),
                Lesson(id: 3, title: "Functions", status: .pending),
                Lesson(id: 4, title: "OOP", status: .pending)
            ]
        )

        let updated = ProgressCalculator.applyingCompletion(to: course, lessonID: 3)

        XCTAssertEqual(updated.lessons[2].status, .completed)
        XCTAssertEqual(updated.lessons[3].status, .pending)
        XCTAssertEqual(updated.progress, 75)
    }
}

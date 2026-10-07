//
//  Course.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

struct Course: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    var title: String
    var instructor: String
    var progress: Int
    var lessonCount: Int
    var lessons: [Lesson]
}

//
//  CourseCacheStore.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

protocol CourseCaching: Sendable {
    func save(_ courses: [Course]) throws
    func load() -> [Course]?
    func clear()
}

struct FileCourseCache: CourseCaching {
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(fileManager: FileManager = .default) {
        let folder = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("LearningDashboard", isDirectory: true)
        try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        self.fileURL = folder.appendingPathComponent("courses-cache.json")
    }

    func save(_ courses: [Course]) throws {
        let data = try encoder.encode(courses)
        try data.write(to: fileURL, options: [.atomic])
    }

    func load() -> [Course]? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? decoder.decode([Course].self, from: data)
    }

    func clear() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}

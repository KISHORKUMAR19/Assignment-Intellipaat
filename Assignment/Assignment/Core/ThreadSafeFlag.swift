//
//  ThreadSafeFlag.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

final class ThreadSafeFlag: @unchecked Sendable {
    private let lock = NSLock()
    private var value: Bool

    init(_ value: Bool) {
        self.value = value
    }

    func get() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    func set(_ value: Bool) {
        lock.lock()
        self.value = value
        lock.unlock()
    }
}

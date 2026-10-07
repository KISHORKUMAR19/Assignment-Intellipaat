//
//  NetworkMonitor.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation
import Network

@MainActor
@Observable
final class NetworkMonitor {
    private(set) var isOnline = true
    let onlineFlag: ThreadSafeFlag
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "LearningDashboard.NetworkMonitor")

    init(onlineFlag: ThreadSafeFlag = ThreadSafeFlag(true)) {
        self.onlineFlag = onlineFlag
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            onlineFlag.set(online)
            Task { @MainActor in
                self?.isOnline = online
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}

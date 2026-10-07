//
//  SessionStore.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

struct SessionStore {
    private let key = "ld.isLoggedIn"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isLoggedIn: Bool {
        get { defaults.bool(forKey: key) }
        nonmutating set { defaults.set(newValue, forKey: key) }
    }
}

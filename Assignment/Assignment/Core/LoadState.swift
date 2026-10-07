//
//  LoadState.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import Foundation

enum LoadState<Value>: Equatable where Value: Equatable {
    case idle
    case loading
    case success(Value)
    case empty
    case failure(String)
}

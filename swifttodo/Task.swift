//
//  Task.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

struct Task: Identifiable, Codable {
    let id = UUID() // Unique identifier for each task
    var title: String
    var isCompleted: Bool = false
}

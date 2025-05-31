//
//  Task.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var category: String
    var dueDate: Date?
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, category: String = "Personal", dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
        self.dueDate = dueDate
    }
}

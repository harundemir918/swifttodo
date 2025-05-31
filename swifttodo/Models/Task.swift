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
    var priority: Priority
    
    enum Priority: String, Codable, CaseIterable {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
        
        var sortIndex: Int {
            switch self {
            case .high: return 0
            case .medium: return 1
            case .low: return 2
            }
        }
    }
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, category: String = "Personal", dueDate: Date? = nil, priority: Priority = .medium) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.category = category
        self.dueDate = dueDate
        self.priority = priority
    }
}

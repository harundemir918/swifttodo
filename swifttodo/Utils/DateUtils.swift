//
//  DateUtils.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

struct DateUtils {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static let calendar = Calendar.current
    
    static func currentDateString() -> String {
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    static func greeting() -> String {
        let hour = calendar.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning!"
        case 12..<17: return "Good afternoon!"
        case 17..<22: return "Good evening!"
        default: return "Good night!"
        }
    }
}

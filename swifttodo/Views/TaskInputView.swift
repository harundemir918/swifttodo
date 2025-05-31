//
//  TaskInputView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct TaskInputView: View {
    @Binding var newTaskTitle: String
    let onAddTask: (String, Date?, Task.Priority) -> Void
    @State private var selectedCategory: String = "Personal"
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date()
    @State private var selectedPriority: Task.Priority = .medium
    
    private let categories = ["Work", "Personal", "Shopping", "Health", "Home", "Finance", "Study", "Travel", "Hobbies", "Events"]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                ZStack(alignment: .leading) {
                    if newTaskTitle.isEmpty {
                        Text("Add a new task...")
                            .foregroundColor(.gray.opacity(0.8))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    TextField("", text: $newTaskTitle)
                        .tint(Color.orange)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                
                Button(action: {
                    let finalDueDate = hasDueDate ? dueDate : nil
                    onAddTask(selectedCategory, finalDueDate, selectedPriority)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 24))
                }
                .padding(.leading, 5)
            }
            
            HStack(spacing: 10) {
                Menu {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            HStack {
                                Text(category)
                                    .foregroundColor(.white)
                                if category == selectedCategory {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                    }
                } label: {
                    Text("Category: \(selectedCategory)")
                        .foregroundColor(.orange)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.1))
                        )
                }
                
                Menu {
                    ForEach(Task.Priority.allCases, id: \.self) { priority in
                        Button(action: {
                            selectedPriority = priority
                        }) {
                            HStack {
                                Text(priority.rawValue)
                                    .foregroundColor(.white)
                                if priority == selectedPriority {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                    }
                } label: {
                    Text("Priority: \(selectedPriority.rawValue)")
                        .foregroundColor(.orange)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal)
            
            // Due Date Toggle and Picker
            Toggle("Set Due Date", isOn: $hasDueDate)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .tint(Color.orange)
            
            if hasDueDate {
                DatePicker("Due Date",
                           selection: $dueDate,
                           displayedComponents: [.date, .hourAndMinute])
                    .tint(Color.orange)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .datePickerStyle(.compact)
                    .colorScheme(.dark)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

struct TaskInputView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInputView(newTaskTitle: .constant(""), onAddTask: { _, _, _ in })
            .background(Color.black.opacity(0.9))
    }
}

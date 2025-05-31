//
//  TaskRow.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct TaskRow: View {
    let task: Task
    let onToggle: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteConfirmation = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var isOverdue: Bool {
        guard let dueDate = task.dueDate else { return false }
        return dueDate < Date() && !task.isCompleted
    }
    
    var priorityColor: Color {
        switch task.priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox for completion
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isCompleted ? .orange : .white.opacity(0.6))
                    .font(.system(size: 20))
            }
            
            // Task title, category, due date, and priority indicator
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(priorityColor)
                        .frame(width: 8, height: 8)
                    Text(task.title)
                        .foregroundColor(task.isCompleted ? .gray : .white)
                        .strikethrough(task.isCompleted, color: .white.opacity(0.4))
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                Text(task.category)
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                if let dueDate = task.dueDate {
                    Text("Due: \(dateFormatter.string(from: dueDate))")
                        .foregroundColor(isOverdue ? .red : .white.opacity(0.6))
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                }
            }
            
            Spacer()
            
            // Delete button
            Button(action: { showingDeleteConfirmation = true }) {
                Image(systemName: "trash")
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal)
        .confirmationDialog("Are you sure?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut) {
                    onDelete()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(
            task: Task(title: "Sample Task", category: "Work", dueDate: Date(), priority: .high),
            onToggle: {},
            onDelete: {}
        )
        .background(Color(red: 26/255, green: 26/255, blue: 26/255))
    }
}

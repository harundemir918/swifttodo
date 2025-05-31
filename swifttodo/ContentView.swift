//
//  ContentView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskStore = TaskStore()
    @State private var newTaskTitle = ""
    @State private var showingAddTask = false
    
    // Current date and time
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
    
    private let calendar = Calendar.current
    private var currentDate: Date { Date() }
    private var greeting: String {
        let hour = calendar.component(.hour, from: currentDate)
        switch hour {
        case 5..<12: return "Good morning!"
        case 12..<17: return "Good afternoon!"
        case 17..<22: return "Good evening!"
        default: return "Good night!"
        }
    }
    
    var remainingTasks: Int {
        taskStore.tasks.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        ZStack {
            // Solid dark background with subtle overlay
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header with date, time, and greeting
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(greeting)
                            .font(.system(size: 24, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        Text(dateFormatter.string(from: currentDate))
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Task input section
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
                            .tint(Color.orange) // Set cursor color to orange
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
                        if !newTaskTitle.isEmpty {
                            withAnimation(.easeInOut) {
                                taskStore.addTask(newTaskTitle)
                                newTaskTitle = ""
                            }
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 24))
                    }
                    .padding(.leading, 5)
                }
                .padding(.horizontal)
                
                // Task list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(taskStore.tasks) { task in
                            TaskRow(task: task, onToggle: {
                                withAnimation(.easeInOut) {
                                    taskStore.toggleCompletion(for: task)
                                }
                            }, onDelete: {
                                withAnimation(.easeInOut) {
                                    if let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) {
                                        taskStore.tasks.remove(at: index)
                                    }
                                }
                            })
                        }
                    }
                }
                
                // Remaining tasks indicator
                Text("Remaining: \(remainingTasks) tasks")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                Spacer()
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox for completion
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(task.isCompleted ? .orange : .white.opacity(0.6))
                    .font(.system(size: 20))
            }
            
            // Task title
            Text(task.title)
                .foregroundColor(.white)
                .strikethrough(task.isCompleted, color: .white.opacity(0.4))
                .font(.system(size: 16, weight: .medium, design: .rounded))
            
            Spacer()
            
            // Delete button
            Button(action: onDelete) {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

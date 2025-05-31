//
//  TaskStore.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks() // Save tasks whenever they change
        }
    }
    
    private let tasksKey = "tasks"
    
    init() {
        loadTasks() // Load tasks when the store is initialized
    }
    
    // Load tasks from UserDefaults
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let savedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            self.tasks = savedTasks
        }
    }
    
    // Save tasks to UserDefaults
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }
    
    // Add a new task
    func addTask(_ title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty, !tasks.contains(where: { $0.title == trimmedTitle }) else { return }
        let newTask = Task(title: trimmedTitle)
        tasks.append(newTask)
    }
    
    // Delete tasks
    func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // Toggle task completion
    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

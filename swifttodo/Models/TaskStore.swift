//
//  TaskStore.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let fileURL: URL
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = documentsDirectory.appendingPathComponent("tasks.json")
        loadTasks()
    }
    
    // Add a new task with your validation
    func addTask(_ title: String, category: String = "Personal", dueDate: Date? = nil, priority: Task.Priority = .medium) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty, !tasks.contains(where: { $0.title == trimmedTitle }) else { return }
        let newTask = Task(title: trimmedTitle, category: category, dueDate: dueDate, priority: priority)
        tasks.append(newTask)
        saveTasks()
    }
    
    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks.remove(at: index)
            saveTasks()
        }
    }
    
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }
    
    private func loadTasks() {
        do {
            let data = try Data(contentsOf: fileURL)
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            tasks = []
        }
    }
}

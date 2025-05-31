//
//  TaskController.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import Foundation

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] // Directly manage tasks in ViewModel
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"
    @Published var sortOption: SortOption = .dueDate
    
    private let taskStore: TaskStore
    
    enum SortOption: String, CaseIterable {
        case dueDate = "Due Date"
        case priority = "Priority"
        case title = "Title"
    }
    
    init(taskStore: TaskStore = TaskStore()) {
        self.taskStore = taskStore
        self._tasks = Published(initialValue: taskStore.tasks) // Initialize with tasks from TaskStore
    }
    
    var filteredTasks: [Task] {
        var filtered = tasks
        
        // Filter by category
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        // Sort based on selected option
        switch sortOption {
        case .dueDate:
            return filtered.sorted { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
        case .priority:
            return filtered.sorted { $0.priority.sortIndex < $1.priority.sortIndex }
        case .title:
            return filtered.sorted { $0.title < $1.title }
        }
    }
    
    var remainingTasks: Int {
        filteredTasks.filter { !$0.isCompleted }.count
    }
    
    func addTask(title: String, category: String, dueDate: Date?, priority: Task.Priority) {
        if !title.isEmpty {
            taskStore.addTask(title, category: category, dueDate: dueDate, priority: priority)
            self.tasks = taskStore.tasks // Sync tasks after adding
        }
    }
    
    func toggleCompletion(for task: Task) {
        taskStore.toggleCompletion(for: task)
        self.tasks = taskStore.tasks // Sync tasks after toggling
    }
    
    func deleteTask(_ task: Task) {
        taskStore.deleteTask(task) // Use TaskStore's delete method to ensure persistence
        self.tasks = taskStore.tasks // Sync tasks after deletion
    }
}

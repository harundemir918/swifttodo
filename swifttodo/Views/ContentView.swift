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
    @State private var selectedCategory = "All"
    
    var filteredTasks: [Task] {
        if selectedCategory == "All" {
            return taskStore.tasks
        }
        return taskStore.tasks.filter { $0.category == selectedCategory }
    }
    
    var remainingTasks: Int {
        filteredTasks.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HeaderView()
                
                TaskInputView(
                    newTaskTitle: $newTaskTitle,
                    onAddTask: { category in
                        if !newTaskTitle.isEmpty {
                            withAnimation(.easeInOut) {
                                taskStore.addTask(newTaskTitle, category: category)
                                newTaskTitle = ""
                            }
                        }
                    }
                )
                
                CategoryFilterView(selectedCategory: $selectedCategory)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredTasks) { task in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

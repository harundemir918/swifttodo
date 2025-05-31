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
    @State private var searchText = ""
    @State private var sortOption: SortOption = .dueDate
    
    enum SortOption {
        case dueDate
        case priority
        case title
    }
    
    var filteredTasks: [Task] {
        var tasks = taskStore.tasks
        
        // Filter by category
        if selectedCategory != "All" {
            tasks = tasks.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            tasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
        // Sort based on selected option
        switch sortOption {
        case .dueDate:
            return tasks.sorted { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
        case .priority:
            return tasks.sorted { $0.priority.sortIndex < $1.priority.sortIndex }
        case .title:
            return tasks.sorted { $0.title < $1.title }
        }
    }
    
    var remainingTasks: Int {
        filteredTasks.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        ZStack {
            Color(red: 26/255, green: 26/255, blue: 26/255) // #1a1a1a
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HeaderView()
                
                // Button to trigger bottom sheet (only the "+" icon)
                Button(action: { showingAddTask = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 24))
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingAddTask) {
                    VStack(alignment: .leading) {
                        TaskInputView(
                            newTaskTitle: $newTaskTitle,
                            onAddTask: { category, dueDate, priority in
                                if !newTaskTitle.isEmpty {
                                    withAnimation(.easeInOut) {
                                        taskStore.addTask(newTaskTitle, category: category, dueDate: dueDate, priority: priority)
                                        newTaskTitle = ""
                                        showingAddTask = false // Dismiss sheet after adding
                                    }
                                }
                            }
                        )
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color(red: 26/255, green: 26/255, blue: 26/255)) // #1a1a1a
                }
                
                // Search and Sort Controls
                HStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty {
                            Text("Search tasks...")
                                .foregroundColor(.gray.opacity(0.8))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        TextField("", text: $searchText)
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
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    
                    Menu {
                        Button(action: { sortOption = .dueDate }) {
                            Text("Due Date")
                        }
                        Button(action: { sortOption = .priority }) {
                            Text("Priority")
                        }
                        Button(action: { sortOption = .title }) {
                            Text("Title")
                        }
                    } label: {
                        Text("Sort: \(sortOption == .dueDate ? "Due Date" : sortOption == .priority ? "Priority" : "Title")")
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

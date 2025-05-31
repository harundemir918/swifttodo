//
//  ContentView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    @State private var showingAddTask = false
    
    var body: some View {
        ZStack {
            Color(red: 26/255, green: 26/255, blue: 26/255) // #1a1a1a
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HeaderView()
                
                // Search and Sort Controls
                HStack(spacing: 10) {
                    ZStack(alignment: .leading) {
                        if viewModel.searchText.isEmpty {
                            Text("Search tasks...")
                                .foregroundColor(.gray.opacity(0.8))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        TextField("", text: $viewModel.searchText)
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
                        Button(action: { viewModel.sortOption = .dueDate }) {
                            Text("Due Date")
                        }
                        Button(action: { viewModel.sortOption = .priority }) {
                            Text("Priority")
                        }
                        Button(action: { viewModel.sortOption = .title }) {
                            Text("Title")
                        }
                    } label: {
                        Text("Sort: \(viewModel.sortOption.rawValue)")
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
                
                CategoryFilterView(selectedCategory: $viewModel.selectedCategory)
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.filteredTasks) { task in
                            TaskRow(task: task, onToggle: {
                                withAnimation(.easeInOut) {
                                    viewModel.toggleCompletion(for: task)
                                }
                            }, onDelete: {
                                withAnimation(.easeInOut) {
                                    viewModel.deleteTask(task)
                                }
                            })
                        }
                    }
                }
                
                Text("Remaining: \(viewModel.remainingTasks) tasks")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                // Add New Task Button at the bottom
                Button(action: { showingAddTask = true }) {
                    Text("Add New Task")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingAddTask) {
            VStack(alignment: .leading) {
                TaskInputView(
                    newTaskTitle: $newTaskTitle,
                    onAddTask: { category, dueDate, priority in
                        if !newTaskTitle.isEmpty {
                            withAnimation(.easeInOut) {
                                viewModel.addTask(title: newTaskTitle, category: category, dueDate: dueDate, priority: priority)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

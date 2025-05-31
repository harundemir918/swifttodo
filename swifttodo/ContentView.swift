//
//  ContentView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskStore = TaskStore() // Manages tasks
    @State private var newTaskTitle = "" // Tracks text field input
    
    var body: some View {
        NavigationView {
            VStack {
                // Text field and Add button
                HStack {
                    TextField("Enter task", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        if !newTaskTitle.isEmpty {
                            taskStore.addTask(newTaskTitle)
                            newTaskTitle = "" // Clear the text field
                        }
                    }) {
                        Text("Add")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical)
                
                // Task list
                List {
                    ForEach(taskStore.tasks) { task in
                        HStack {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                            Spacer()
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    taskStore.toggleCompletion(for: task)
                                }
                        }
                    }
                    .onDelete(perform: taskStore.deleteTasks)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("ToDo List")
            .toolbar {
                EditButton() // Adds Edit button for deleting tasks
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

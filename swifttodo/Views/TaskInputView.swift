//
//  TaskInputView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct TaskInputView: View {
    @Binding var newTaskTitle: String
    let onAddTask: () -> Void
    
    var body: some View {
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
            
            Button(action: onAddTask) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 24))
            }
            .padding(.leading, 5)
        }
        .padding(.horizontal)
    }
}

struct TaskInputView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInputView(newTaskTitle: .constant(""), onAddTask: {})
            .background(Color.black.opacity(0.9))
    }
}

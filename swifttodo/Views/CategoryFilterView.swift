//
//  CategoryFilterView.swift
//  swifttodo
//
//  Created by Harun Demir on 31.05.2025.
//

import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategory: String
    let categories = ["All", "Work", "Personal", "Shopping", "Health", "Home", "Finance", "Study", "Travel", "Hobbies", "Events"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(selectedCategory == category ? .orange : .white.opacity(0.6))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedCategory == category ? Color.orange.opacity(0.2) : Color.white.opacity(0.1))
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFilterView(selectedCategory: .constant("All"))
            .background(Color.black.opacity(0.9))
    }
}

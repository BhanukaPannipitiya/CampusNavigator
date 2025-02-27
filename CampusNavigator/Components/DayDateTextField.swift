//
//  DayDateTextField.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-25.
//

//
//  DayDateTextField.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-25.
//

import SwiftUI

struct DayDateTextField: View {
    let date: Date
    let time: String
    let isSelected: Bool // Track selection state
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 5) {
                Text("\(formattedDate(date))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity) // Center the text horizontally
                
                Text("Available Time - \(time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6)) // Background color similar to LabelTextField
            .cornerRadius(20)
            .shadow(radius: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.red : Color.mint, lineWidth: 0.8) // Border color change on selection
            )
        }
        .frame(maxWidth: .infinity) // Ensure the entire content is centered
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    DayDateTextField(date: Date(), time: "11:00 AM", isSelected: false) // Use the current date for preview
}


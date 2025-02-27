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
    let isDisabled: Bool // Track whether the slot is booked
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 5) {
                Text("\(formattedDate(date))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity) // Center the text horizontally
                    .foregroundColor(isDisabled ? .gray : .black) // Gray text if disabled
                
                Text("Available Time - \(time)")
                    .font(.subheadline)
                    .foregroundColor(isDisabled ? .gray.opacity(0.7) : .gray)
            }
            .padding()
            .background(isDisabled ? Color(.systemGray5) : Color(.systemGray6)) // Dimmed background for disabled slots
            .cornerRadius(20)
            .shadow(radius: isDisabled ? 0 : 1) // Remove shadow if disabled
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isDisabled ? Color.gray : (isSelected ? Color.red : Color.mint), lineWidth: 0.8) // Gray border if disabled
            )
        }
        .frame(maxWidth: .infinity) // Ensure the entire content is centered
        .padding()
        .opacity(isDisabled ? 0.5 : 1.0) // Reduce opacity for disabled slots
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    VStack {
        DayDateTextField(date: Date(), time: "11:00 AM", isSelected: false, isDisabled: false) // Active slot
        DayDateTextField(date: Date(), time: "2:00 PM", isSelected: false, isDisabled: true) // Booked slot (disabled)
    }
}

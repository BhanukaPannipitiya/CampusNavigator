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
    let isSelected: Bool
    let isDisabled: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 5) {
                Text("\(formattedDate(date))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isDisabled ? .gray : .black)
                
                Text("Available Time - \(time)")
                    .font(.subheadline)
                    .foregroundColor(isDisabled ? .gray.opacity(0.7) : .gray)
            }
            .padding()
            .background(isDisabled ? Color(.systemGray5) : Color(.systemGray6))
            .cornerRadius(20)
            .shadow(radius: isDisabled ? 0 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isDisabled ? Color.gray : (isSelected ? Color.red : Color.mint), lineWidth: 0.8)
            )
        }
        .frame(maxWidth: .infinity)
        .padding()
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    VStack {
        DayDateTextField(date: Date(), time: "11:00 AM", isSelected: false, isDisabled: false)
        DayDateTextField(date: Date(), time: "2:00 PM", isSelected: false, isDisabled: true) 
    }
}

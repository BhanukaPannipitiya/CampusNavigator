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
    
    var body: some View {
        VStack {
            Text("\(formattedDate(date)) at \(time)")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity) // Center the text horizontally
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.mint, lineWidth: 0.2))
                .foregroundColor(.black)
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    DayDateTextField(date: Date(), time: "11.00") // Use the current date for preview
}

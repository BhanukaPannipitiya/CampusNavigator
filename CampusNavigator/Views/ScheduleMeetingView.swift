//
//  ScheduleMeetingView.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-24.
//

import SwiftUI

struct ScheduleMeetingView: View {
    let lecturer: Lecturer
    @State private var selectedDate = Date()
    @State private var randomTime1 = ""
    @State private var randomTime2 = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(spacing: 0) {
                        VStack (alignment: .leading, spacing: 12) {
                            
                            Text(lecturer.title)
                                .font(.system(size: 28, weight: .bold))
                                .padding(.top, 28)
                            
                            Text(lecturer.description)
                                .font(.subheadline)
                                .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                            
                            LabelText(title: "Available Times")
                                .padding(.bottom,15)
                            
                            DatePicker("Select a Date", selection: $selectedDate, displayedComponents: [.date])
                                .accentColor(.red)
                                .datePickerStyle(.graphical)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10) // Rounded corners
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.mint, lineWidth: 0.2)
                                         
                                )
                            
                            DayDateTextField(date: selectedDate, time: randomTime1)
                            
                            DayDateTextField(date: selectedDate, time: randomTime2)
                            
                            Spacer(minLength: 20) // Add some padding at the bottom
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            // Initialize times when view appears
            randomTime1 = generateRandomTime()
            randomTime2 = generateRandomTime()
        }
        .onChange(of: selectedDate) { _ in
            randomTime1 = generateRandomTime()
            randomTime2 = generateRandomTime()
        }
    }
    
    private func generateRandomTime() -> String {
        let hour = Int.random(in: 8...18)  // Random hour between 8 AM and 6 PM
        let minute = Int.random(in: 0...59)  // Random minute between 0 and 59
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:00 a"  // 12-hour format
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        if let randomDate = calendar.date(from: components) {
            return timeFormatter.string(from: randomDate)
        } else {
            return "10:00 AM"  // Default time
        }
    }
}

#Preview {
    ScheduleMeetingView(lecturer: Lecturer(title: "Dr. Sample Lecturer", description: "Meeting discussion on research topics"))
}

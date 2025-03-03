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
    @State private var isKeyboardVisible = false
    @State private var selectedTime = ""
    @State private var showConfirmation = false
    @State private var bookedSlots: Set<String> = []

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
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
                            
                            let slot1 = formattedDate(selectedDate) + " " + randomTime1
                            let slot2 = formattedDate(selectedDate) + " " + randomTime2

                            // Time slot 1
                            Button(action: {
                                if !bookedSlots.contains(slot1) {
                                    selectedTime = randomTime1
                                }
                            }) {
                                DayDateTextField(
                                    date: selectedDate,
                                    time: randomTime1,
                                    isSelected: selectedTime == randomTime1,
                                    isDisabled: bookedSlots.contains(slot1)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(bookedSlots.contains(slot1))

                            Button(action: {
                                if !bookedSlots.contains(slot2) {
                                    selectedTime = randomTime2
                                }
                            }) {
                                DayDateTextField(
                                    date: selectedDate,
                                    time: randomTime2,
                                    isSelected: selectedTime == randomTime2,
                                    isDisabled: bookedSlots.contains(slot2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(bookedSlots.contains(slot2))

                            CustomButton(
                                isKeyboardVisible: $isKeyboardVisible,
                                buttonText: "Book Now",
                                buttonBackgroundColor: Color.mint,
                                buttonTextColor: .white,
                                fontSize: 18,
                                action: {
                                    if !selectedTime.isEmpty {
                                        showConfirmation = true
                                    }
                                }
                            )
                            .frame(height: 60) 
                            .disabled(selectedTime.isEmpty)
                            .opacity(selectedTime.isEmpty ? 0.6 : 1.0)
                            
                            Spacer(minLength: 20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .blur(radius: showConfirmation ? 8 : 0)
            }
        }
        .alert("Booking Confirmed!", isPresented: $showConfirmation, actions: {
            Button("OK", role: .cancel) {
                bookedSlots.insert(formattedDate(selectedDate) + " " + selectedTime)
                selectedTime = ""
                showConfirmation = false
            }
        }, message: {
            Text("Let's meet at \(formattedDate(selectedDate)) at \(selectedTime).")
        })
        .onAppear {
           
            randomTime1 = generateRandomTime()
            randomTime2 = generateRandomTime()
        }
        .onChange(of: selectedDate) { _ in
            randomTime1 = generateRandomTime()
            randomTime2 = generateRandomTime()
            selectedTime = ""
        }
    }
    
    // Helper to format the date nicely
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func generateRandomTime() -> String {
        let hour = Int.random(in: 8...18)
        let minute = Int.random(in: 0...59)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:00 a"
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        if let randomDate = calendar.date(from: components) {
            return timeFormatter.string(from: randomDate)
        } else {
            return "10:00 AM"
        }
    }
}

#Preview {
    ScheduleMeetingView(lecturer: Lecturer(title: "Dr. Sample Lecturer", description: "Meeting discussion on research topics"))
}

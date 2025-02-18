//
//  MeetingLecturesView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-17.
//

import SwiftUI

struct Lecturer: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct MeetingLecturesView: View {
    @State private var selectedLecturer: Lecturer? = nil
    @State private var isEventDetailPresented = false
    @State private var isAddEventPresented = false
    
    let lecturers: [Lecturer] = [
        Lecturer(title: "Dr. John Jhones", description: "Schedule a meeting about course selection"),
        Lecturer(title: "Dr. Sarah Smith", description: "Discuss research project opportunities"),
        Lecturer(title: "Dr. Emily Wilson", description: "Request thesis supervision meeting"),
        Lecturer(title: "Dr. Michael Brown", description: "Consult about academic progress"),
        Lecturer(title: "Dr. Lisa Taylor", description: "Talk about internship possibilities")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meeting Lecturers")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.top, 25)
                        
                        Text("Select a lecturer to schedule a meeting")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    
                    // Lecturers List
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(lecturers) { lecturer in
                                LecturerCard(lecturer: lecturer)
                                    .onTapGesture {
                                        selectedLecturer = lecturer
                                        isEventDetailPresented = true
                                    }
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                    }
                }
                
                // Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isAddEventPresented = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 56))
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                    }
                }
            }
        }
        .sheet(isPresented: $isEventDetailPresented) {
            if let lecturer = selectedLecturer {
                LecturerDetailView(lecturer: lecturer)
            }
        }
        .sheet(isPresented: $isAddEventPresented) {
            AddMeetingView()
        }
    }
}

struct LecturerCard: View {
    let lecturer: Lecturer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(lecturer.title)
                .font(.system(size: 18, weight: .semibold))
            
            Text(lecturer.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct LecturerDetailView: View {
    let lecturer: Lecturer
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }
            
            VStack(spacing: 20) {
                Text(lecturer.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text(lecturer.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Button(action: {}) {
                    Text("Schedule Meeting")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 30)
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

struct AddMeetingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var meetingDetails = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                Spacer()
                Text("New Meeting")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            Form {
                Section(header: Text("Meeting Details")) {
                    TextField("Enter meeting purpose", text: $meetingDetails)
                }
                
                Section {
                    DatePicker("Select Date", selection: .constant(Date()))
                }
            }
        }
    }
}


struct MeetingLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingLecturesView()
    }
}

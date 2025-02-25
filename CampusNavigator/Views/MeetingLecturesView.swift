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
    @State private var searchText: String = ""
    
    
    let lecturers: [Lecturer] = [
        Lecturer(title: "Dr. John Jhones", description: "Schedule a meeting about course selection"),
        Lecturer(title: "Dr. Sarah Smith", description: "Discuss research project opportunities"),
        Lecturer(title: "Dr. Emily Wilson", description: "Request thesis supervision meeting"),
        Lecturer(title: "Dr. Michael Brown", description: "Consult about academic progress"),
        Lecturer(title: "Dr. Lisa Taylor", description: "Talk about internship possibilities")
    ]
    
    var filteredLecturers: [Lecturer] {
            if searchText.isEmpty {
                return lecturers
            } else {
                return lecturers.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
            }
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                /*Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)*/
                Color(.white)
                
                VStack(spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Meeting Lecturers")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.top, 28)
                        
                        Text("Schedule a meeting with lecturers.")
                            .font(.subheadline)
                            .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // Search Bar
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.5))
                            
                            TextField("Search by lecturers name", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.5))
                            
                        }
                        
                        .padding(.horizontal)
                        .padding(10)
                        .background(Color(.sRGB, red: 242/255, green: 242/255, blue: 247/255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.sRGB, red: 142/255, green: 142/255, blue: 147/255, opacity: 0.1), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom,25)
                    
                    // Lecturers List
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(filteredLecturers) { lecturer in
                                LecturerCard(lecturer: lecturer)
                                    .onTapGesture {
                                        selectedLecturer = lecturer
                                        isEventDetailPresented = true
                                    }
                            }
                        }
                        .padding(.horizontal, 17)
                        .padding(.vertical, 15)
                    }
                }
                
            }
        }
        
    }
}

struct LecturerCard: View {
    let lecturer: Lecturer
    
    var body: some View {
        LabelTextField(
            title: lecturer.title,
            description: lecturer.description,
            destination: AnyView(ScheduleMeetingView(lecturer: lecturer))
        )
    }
}

struct MeetingLecturesView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingLecturesView()
    }
}

//
//  HomeView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("🏫 Campus Navigator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Text("Easily navigate your university campus!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // Navigation Buttons
//                NavigationLink(destination: ARNavigationView()) {
//                    FeatureButton(title: "📍 Find a Building (AR)")
//                }
//                
//                NavigationLink(destination: CampusMapView()) {
//                    FeatureButton(title: "🗺️ Campus Activity Map")
//                }
//                
//                NavigationLink(destination: LiveResourceView()) {
//                    FeatureButton(title: "📊 Check Resource Availability")
//                }
//                
//                NavigationLink(destination: EventsView()) {
//                    FeatureButton(title: "📅 View Campus Events")
//                }
//                
//                NavigationLink(destination: EmergencyView()) {
//                    FeatureButton(title: "🚨 Report an Emergency")
//                }
//                
//                NavigationLink(destination: LecturerMeetingView()) {
//                    FeatureButton(title: "📩 Schedule a Lecturer Meeting")
//                }
//                
//                NavigationLink(destination: ChatView()) {
//                    FeatureButton(title: "💬 Student Chat & Collaboration")
//                }
//                
//                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

// MARK: - Reusable Button Component
struct FeatureButton: View {
    let title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)
            .shadow(radius: 2)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

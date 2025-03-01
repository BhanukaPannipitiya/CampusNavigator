//
//  NotificationsView.swift
//  CampusNavigator
//
//  Created by Bhanuka Pannipitiya on 2025-02-26.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Recent Notifications", systemImage: "bell.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        NotificationItem(
                            title: "Campus Alert",
                            message: "Construction on West Campus may cause delays. Please plan accordingly.",
                            time: "2 hours ago",
                            icon: "cone.fill",
                            color: .orange
                        )
                        
                        NotificationItem(
                            title: "Weather Advisory",
                            message: "Heavy rain expected this afternoon. Indoor routes recommended.",
                            time: "Today, 8:30 AM",
                            icon: "cloud.rain.fill",
                            color: .blue
                        )
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.mint.opacity(0.1))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.mint, lineWidth: 1)
                    )
                }
                .padding()
            }
            .navigationTitle("Notifications")
        }
        .accentColor(.mint)
    }
}

struct EmergencyContactCard: View {
    var title: String
    var description: String
    var icon: String
    var action: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel://\(action.replacingOccurrences(of: "-", with: ""))") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.mint)
                    .frame(width: 40, height: 40)
                    .background(Color.mint.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(action)
                    .font(.callout)
                    .foregroundColor(.mint)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.mint.opacity(0.1))
                    .cornerRadius(16)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NotificationItem: View {
    var title: String
    var message: String
    var time: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

//
//  EmergencyView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-17.
//
import SwiftUI

struct EmergencyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Emergency Contacts", systemImage: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.primary)
            
            EmergencyContactCard(
                title: "Emergency Services",
                description: "Call 119 for immediate assistance",
                icon: "phone.fill",
                action: "119"
            )
            
            EmergencyContactCard(
                title: "Campus Security",
                description: "24/7 campus emergency response",
                icon: "shield.fill",
                action: "01122334455"
            )
            
            EmergencyContactCard(
                title: "Health Center",
                description: "Medical assistance and counseling",
                icon: "heart.fill",
                action: "01123456789"
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
        .padding(.horizontal)
    }
}

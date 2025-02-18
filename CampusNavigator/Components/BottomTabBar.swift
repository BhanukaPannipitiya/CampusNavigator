//
//  BottomTabBar.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI
import UIKit

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Spacer()
            TabButton(icon: "house", title: "Home", tabIndex: 0, selectedTab: $selectedTab)
            Spacer()
            TabButton(icon: "magnifyingglass", title: "Search", tabIndex: 1, selectedTab: $selectedTab)
            Spacer()
            TabButton(icon: "person", title: "Profile", tabIndex: 2, selectedTab: $selectedTab)
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: 54)
        .background(
            // Glass effect using Blur and Opacity
            BlurView(style: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25)) // Rounded corners
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4) // Soft shadow
                .padding(.horizontal, 16) // Padding to make it float a bit
        )
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let tabIndex: Int
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(selectedTab == tabIndex ? .blue : .gray)
            Text(title)
                .font(.caption)
                .foregroundColor(selectedTab == tabIndex ? .blue : .gray)
        }
        .padding()
        .onTapGesture {
            selectedTab = tabIndex
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}



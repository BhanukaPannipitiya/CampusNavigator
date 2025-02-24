//
//  BottomTabBar.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case map = "Map"
    case emergency = "Emergency"
}


struct BottomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { item in
                Button(action: {
                    selectedTab = item
                }) {
                    VStack {
                        Image(systemName: iconName(for: item))
                            .font(.title2)
                        Text(item.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == item ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top)
        .frame(height: 70)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
    
    private func iconName(for tab: TabItem) -> String {
        switch tab {
        case .home: return "house.fill"
        case .map: return "map.fill"
        case .emergency: return "exclamationmark.triangle.fill"
        }
    }
}



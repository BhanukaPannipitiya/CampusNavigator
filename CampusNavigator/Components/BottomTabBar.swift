//
//  BottomTabBar.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
        
        var body: some View {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                ActivityMapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
                    .tag(1)
                
                EmergencyView()
                    .tabItem {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Emergency")
                    }
                    .tag(2)
            }
            .accentColor(.mint)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
}


#Preview {
    BottomTabBar(selectedTab: .constant(0))
}

//
//  MainView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tag(0)
                
                ActivityMapView()
                    .tag(1)
                
                EmergencyView()
                    .tag(2)
            }
            .tabViewStyle(.automatic)

            BottomTabBar(selectedTab: $selectedTab)
        }
    }
}

//
//  CampusNavigatorApp.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI

@main
struct CampusNavigatorApp: App {
    @State private var isLoggedIn = false
    @State private var isVerified = false
    
    var body: some Scene {
        WindowGroup {
            if !isLoggedIn {
                LoginView(isLoggedIn: $isLoggedIn)
            } else if !isVerified {
                VerificationCodeView(isVerified: $isVerified)
            } else {
                BottomTabBar(selectedTab: .constant(0))
            }
        }
    }
}

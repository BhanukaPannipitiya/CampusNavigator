//
//  Button.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//
import SwiftUI

struct CustomButton: View {
    @Binding var isKeyboardVisible: Bool
    var buttonText: String
    var buttonBackgroundColor: Color
    var buttonTextColor: Color
    var fontSize: CGFloat
    var action: () -> Void

    var body: some View {
        SwiftUI.Button(action: {
            self.isKeyboardVisible = false
            action()
        }) {
            HStack {
                Text(buttonText)
            }
            .font(.system(size: fontSize, weight: .bold, design: .default))
            .foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(buttonBackgroundColor)
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}




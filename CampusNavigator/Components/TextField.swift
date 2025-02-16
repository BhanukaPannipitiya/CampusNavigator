//
//  TextField.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-16.
//

import SwiftUI

struct TextField: View {
    @Binding var text: String
    @Binding var isKeyboardVisible: Bool
    var placeholder: String
    var textColor: Color
    var backgroundColor: Color
    var fontSize: CGFloat
    var labelText: String
    var labelTextColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(labelText)
                .font(.system(size: 15, weight: .regular, design: .default))
                .foregroundColor(labelTextColor)
            
            SwiftUI.TextField(placeholder, text: $text)
                .padding(12)
                .background(backgroundColor)
                .cornerRadius(8)
                .foregroundColor(textColor)
                .font(.system(size: fontSize))
                .autocorrectionDisabled(true)
                .onTapGesture {
                    withAnimation {
                        self.isKeyboardVisible = true
                    }
                }
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
}



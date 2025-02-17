//
//  VerifyCodeSquare.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-16.
//

import SwiftUI

struct VerifyCodeSquare: View {
    @Binding var value: String
    var isFocused: Bool
    var borderColor: Color
    var backgroundColor: Color
    var textColor: Color
    var fontSize: CGFloat
    var cornerRadius: CGFloat
    var frameSize: CGFloat

    var body: some View {
        SwiftUI.TextField("", text: $value)
            .frame(width: frameSize, height: frameSize)
            .font(.system(size: fontSize, weight: .bold))
            .multilineTextAlignment(.center)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isFocused ? borderColor : Color.gray, lineWidth: 2)
            )
            .keyboardType(.numberPad)
    }
}

// Preview
struct VerifyCodeSquare_Previews: PreviewProvider {
    static var previews: some View {
        VerifyCodeSquare(
            value: .constant(""),
            isFocused: true,
            borderColor: .blue,
            backgroundColor: .white,
            textColor: .black,
            fontSize: 24,
            cornerRadius: 10,
            frameSize: 50
        )
    }
}

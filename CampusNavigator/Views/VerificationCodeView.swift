//
//  VerificationCodeView.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-16.
//

import SwiftUI

struct VerificationCodeView: View {
    @State private var otpValues: [String] = Array(repeating: "", count: 4) // Four squares
    @FocusState private var focusedField: Int?
    @State private var isKeyboardVisible = false

    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 10) {
                    Text("Navigate your campus with ease")
                        .font(.system(size: 18.5, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    Text("Let's get you ")
                        .font(.system(size: 42, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    Text("there!")
                        .font(.system(size: 42, weight: .heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    
                    Text("Enter the Code")
                        .font(.system(size: 16, weight: .light))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top,30)
                    
                    // Centered OTP Verification Squares with equal spacing
                    HStack(spacing: 30) {
                        ForEach(0..<otpValues.count, id: \.self) { index in
                            VerifyCodeSquare(
                                value: $otpValues[index],
                                isFocused: focusedField == index,
                                borderColor: .blue,
                                backgroundColor: .white,
                                textColor: .black,
                                fontSize: 24,
                                cornerRadius: 10,
                                frameSize: 50
                            )
                            .focused($focusedField, equals: index)
                            .onChange(of: otpValues[index]) { newValue, oldValue in
                                // Allow only numeric input and limit to one digit.
                                let filtered = newValue.filter { $0.isNumber }
                                let limited = String(filtered.prefix(1))
                                if otpValues[index] != limited {
                                    otpValues[index] = limited
                                }
                                // If a digit is entered in an empty field, move focus to the next square.
                                if limited.count == 1 && oldValue.isEmpty {
                                    DispatchQueue.main.async {
                                        if index < otpValues.count - 1 {
                                            focusedField = index + 1
                                        } else {
                                            // Remain on the last field if this is the final digit.
                                            focusedField = index
                                        }
                                    }
                                }
                            }
                        }
                    }
                   
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10) // Gap between text and squares
                    
                    CustomButton(
                        isKeyboardVisible: $isKeyboardVisible,
                        buttonText: "Next",
                        buttonBackgroundColor: Color.blue,
                        buttonTextColor: .white,
                        fontSize: 16,
                        action: {
                            print("Next button pressed")
                        }
                    )
                    .padding(.top, 20)
                    
                    VStack {
                        Image("verifycode")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 270)
                            .padding(.top, 100)
                    }
                    .padding(.leading)
                }
                
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            }
            Spacer()
        }
        .onAppear {
            // Automatically focus on the first square when the view appears.
            focusedField = 0
        }
    }
}

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}

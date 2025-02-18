//
//  LoginView.swift
//  CampusNavigator
//
//  Created by Bhanuka Pannipitiya on 2025-02-16.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var isKeyboardVisible = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                GeometryReader { geometry in
                    VStack {
                        VStack(spacing: 10) {
                            Text("Navigate your campus with ease")
                                .font(.system(size: 18.5, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            
                            Text("Let's get you ")
                                .font(.system(size: 42, weight: .heavy, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 16)
                            
                            Text("there!")
                                .font(.system(size: 42, weight: .heavy, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }
                        
                        CustomTextField(
                            text: $email,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "ex.yr3cobsccomp232f-001",
                            textColor: Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6),
                            backgroundColor: Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.1),
                            fontSize: 15,
                            labelText: "What is your campus email address?",
                            labelTextColor: Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6)
                        )
                        
                        CustomButton(
                            isKeyboardVisible: $isKeyboardVisible,
                            buttonText: "Next",
                            buttonBackgroundColor: Color.blue,
                            buttonTextColor: .white,
                            fontSize: 16,
                            action: {
                                navigationPath.append("VerificationCode") 
                            }
                        )
                        
                        Spacer()
                        
                        Image("LoginPage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 375, height: 291)
                            .padding(.top, 100)
                        
                        Spacer()
                    }
                    .padding(.bottom, isKeyboardVisible ? geometry.safeAreaInsets.bottom : 0)
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "VerificationCode" {
                    VerificationCodeView()
                }
            }
        }
        .padding(.top, 20)
        .frame(maxHeight: .infinity)
        .onTapGesture {
            self.isKeyboardVisible = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

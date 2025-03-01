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
    @State private var navigateToVerification = false
    @State private var showEmailError = false
    @Binding var isLoggedIn: Bool
    

    private let primaryColor = Color.mint
    private let secondaryColor = Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6)
    private let backgroundColor = Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.1)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                headerSection
                emailInputSection
                nextButton
                Spacer(minLength: 20)
                Image("LoginPage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .onTapGesture { dismissKeyboard() }
        }
    }
    

    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Navigate your campus with ease")
                .font(.system(size: 18.5, weight: .bold))
                .foregroundColor(secondaryColor)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Let's get you      ")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(.black)
                
                Text("there!")
                    .font(.system(size: 40, weight: .heavy))
                    .foregroundColor(primaryColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top)
    }
    
    private var emailInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What is your campus email address?")
                .font(.system(size: 15))
                .foregroundColor(secondaryColor)
                .padding(.leading, 4)
            
            TextField("ex.yr3cobsccomp232f-001", text: $email)
                .font(.system(size: 15))
                .foregroundColor(secondaryColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .onChange(of: email) { _ in
                    showEmailError = false
                }
                .onTapGesture {
                    isKeyboardVisible = true
                }
            
            if showEmailError {
                Text("Please enter a valid email address")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
        .padding(.top, 20)
    }
    
    private var nextButton: some View {
        Button(action: {
            validateEmailAndNavigate()
        }) {
            Text("Next")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor)
                .cornerRadius(10)
        }
        .padding(.top, 10)
    }
    

    
    private func dismissKeyboard() {
        isKeyboardVisible = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func validateEmailAndNavigate() {
           if email.contains("@") && email.count > 5 {
               isLoggedIn = true
               showEmailError = false
           } else {
               showEmailError = true
           }
       }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}

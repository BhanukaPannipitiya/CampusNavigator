import SwiftUI

struct VerificationCodeView: View {
    @State private var otpValues: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    @State private var isKeyboardVisible = false
    @State private var navigateToHome = false
    @State private var showInvalidCodeError = false
    @Binding var isVerified: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var primaryColor: Color { Color.mint }
    private var secondaryColor: Color {
        colorScheme == .dark
            ? Color(.sRGB, red: 235/255, green: 235/255, blue: 245/255, opacity: 0.6)
            : Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6)
    }
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(.sRGB, red: 120/255, green: 120/255, blue: 130/255, opacity: 0.2)
            : Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.1)
    }
    private var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    private var backgroundFillColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                
                verificationSection
                
                NavigationLink(destination: BottomTabBar(selectedTab: .constant(0)), isActive: $navigateToHome) {
                    EmptyView()
                }
                .hidden()
                
                nextButton
                
                Spacer(minLength: 20)
                
                Image("verifycode")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width - 40)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                    .preferredColorScheme(colorScheme)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundFillColor)
            .onTapGesture {
                dismissKeyboard()
            }
        }
        .onAppear {
            focusedField = 0
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Navigate your campus with ease")
                .font(.system(size: 18.5, weight: .bold))
                .foregroundColor(secondaryColor)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Let's get you ")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(textColor)
                
                Text("there!")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(primaryColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var verificationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Enter the Code")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(secondaryColor)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
                ForEach(0..<otpValues.count, id: \.self) { index in
                    otpTextField(index: index)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 10)
            
            if showInvalidCodeError {
                Text("Please enter a valid 4-digit code")
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
    }
    
    private func otpTextField(index: Int) -> some View {
        TextField("", text: $otpValues[index])
            .keyboardType(.numberPad)
            .frame(width: 60, height: 60)
            .multilineTextAlignment(.center)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(textColor)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(focusedField == index ? primaryColor : Color.clear, lineWidth: 2)
            )
            .focused($focusedField, equals: index)
            .onChange(of: otpValues[index]) { newValue in
                handleOtpInput(index: index, newValue: newValue)
            }
            .onTapGesture {
                isKeyboardVisible = true
            }
    }
    
    private var nextButton: some View {
        Button(action: {
            verifyCodeAndNavigate()
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
    
    private func handleOtpInput(index: Int, newValue: String) {
        let filtered = newValue.filter { $0.isNumber }
        let limited = String(filtered.prefix(1))
        
        if otpValues[index] != limited {
            otpValues[index] = limited
        }
        
        showInvalidCodeError = false
        
        if limited.count == 1 {
            DispatchQueue.main.async {
                if index < otpValues.count - 1 {
                    focusedField = index + 1
                } else {
                    dismissKeyboard()
                }
            }
        }
    }
    
    private func dismissKeyboard() {
        isKeyboardVisible = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func verifyCodeAndNavigate() {
        let enteredCode = otpValues.joined()
        if enteredCode.count == 4 {
            isVerified = true
            showInvalidCodeError = false
        } else {
            showInvalidCodeError = true
            for i in 0..<otpValues.count {
                if otpValues[i].isEmpty {
                    focusedField = i
                    break
                }
            }
        }
    }
}

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VerificationCodeView(isVerified: .constant(false))
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
            VerificationCodeView(isVerified: .constant(false))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

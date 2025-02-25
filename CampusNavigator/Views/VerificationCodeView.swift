import SwiftUI

struct VerificationCodeView: View {
    @State private var otpValues: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    @State private var isKeyboardVisible = false
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
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
                            .padding(.top, 30)

                        // OTP Input Fields
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
                                    let filtered = newValue.filter { $0.isNumber }
                                    let limited = String(filtered.prefix(1))
                                    if otpValues[index] != limited {
                                        otpValues[index] = limited
                                    }
                                    if limited.count == 1 && oldValue.isEmpty {
                                        DispatchQueue.main.async {
                                            if index < otpValues.count - 1 {
                                                focusedField = index + 1
                                            } else {
                                                focusedField = index
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                        // NavigationLink (Hidden) to navigate on button press
                        NavigationLink(destination: BottomTabBar(selectedTab: .constant(0)), isActive: $navigateToHome) {
                            EmptyView()
                        }
                        .hidden()

                        // Next Button
                        CustomButton(
                            isKeyboardVisible: $isKeyboardVisible,
                            buttonText: "Next",
                            buttonBackgroundColor: Color.blue,
                            buttonTextColor: .white,
                            fontSize: 16,
                            action: {
                                verifyCodeAndNavigate()
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
                focusedField = 0
            }
        }
    }

    // Function to verify OTP and navigate
    private func verifyCodeAndNavigate() {
        let enteredCode = otpValues.joined()
        if enteredCode.count == 4 {
            print("OTP Verified: \(enteredCode)")
            navigateToHome = true
        } else {
            print("Invalid OTP")
        }
    }
}

// Preview
struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}


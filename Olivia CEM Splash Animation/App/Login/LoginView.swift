import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    
    @State private var identifier: String = ""
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // Proportional spacing ratio based on 852px / 196px
    private let spacerRatio: CGFloat = 4.347826087
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer(minLength: 0)
                
                VStack(spacing: 0) {
                    // Proportional top spacer based on screen height
                    Color.clear
                        .frame(height: geometry.size.height / spacerRatio)
                    
                    // MARK: Header (hug contents)
                    HeaderBlock(title: "Login")
                    
                    // Flexible spacer with minimum height
                    Spacer(minLength: 20)

                    // MARK: Main Content (hug contents)
                    VStack(spacing: 16) {
                        InputField(
                            label: "Phone Number, Email, or Employee ID",
                            placeholder: "Phone Number, email, or EID",
                            text: $identifier
                        )

                        CustomButton(title: "Next") {
                            // Dismiss keyboard on button tap
                            hideKeyboard()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { 
                        // Dismiss keyboard on tap
                        hideKeyboard()
                    }
                    
                    // Flexible spacer with minimum height
                    Spacer(minLength: 20)

                    // MARK: Footer (hug contents)
                    VStack(spacing: 8) {
                        CustomButton(
                            title: "Sign in with SSO",
                            type: .secondary,
                            leftIcon: Image(systemName: "key.fill")
                        ) { hideKeyboard() }

                        CustomButton(
                            title: "Region: US",
                            type: .utility,
                            width: .hugContents
                        ) { hideKeyboard() }

                        Text("© 2016 - 2025 Olivia by Paradox")
                            .font(.system(size: 14))
                            .foregroundColor(.appTextTertiary)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: horizontalSizeClass == .regular ? LayoutConstants.loginViewMaxWidth : .infinity)
                .padding(.horizontal, LayoutConstants.horizontalPadding)
                .padding(.bottom, 40) // Bottom padding
                
                Spacer(minLength: 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(UIColor.clear))
        }
    }
    
    // MARK: - Helper Methods
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Header Block

private struct HeaderBlock: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.appTextPrimary)
            .padding(.bottom, 40.0)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Preview

#Preview("iPhone SE") {
    LoginView()
}

#Preview("iPad") {
    LoginView()
} 

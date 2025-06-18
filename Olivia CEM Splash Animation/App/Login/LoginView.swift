import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    
    @State private var identifier: String = ""
    // Note: Focus state removed for iOS 13 compatibility
    
    // The design now uses fixed header/footer; no dynamic splash spacing needed.
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                // MARK: Header (fixed height)
                HeaderBlock(title: "Login")
                    .padding(.vertical, 8.0)
                    .frame(height: 96)

                Spacer(minLength: 0)

                // MARK: Main Content (flexible, vertically centered)
                VStack(spacing: 24) {
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
                .padding(.bottom, 40)
                .contentShape(Rectangle())
                .onTapGesture { 
                    // Dismiss keyboard on tap
                    hideKeyboard()
                }
                .frame(maxWidth: 393)
                .frame(maxWidth: .infinity)
                

                Spacer(minLength: 0)

                // MARK: Footer (fixed height)
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
                .padding(.init(top: 8, leading: 0, bottom: 40, trailing: 0))
                .frame(height: 192)
            }
            .frame(maxWidth: 393)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 24.0)
        .edgesIgnoringSafeArea(.all)
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
        VStack {
            Spacer()
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
} 

import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    
    @State private var identifier: String = ""
    @State private var keepSignedIn: Bool = false
    @State private var enableFaceID: Bool = false
    @FocusState private var isInputFieldFocused: Bool
    
    @Environment(\.animationProgressKey) private var animationProgress: CGFloat
    
    // MARK: - Computed Properties
    
    private var spacingValues: (headerToInput: CGFloat, inputToToggles: CGFloat, toggles: CGFloat) {
        let progress = animationProgress
        return (
            headerToInput: 100 - (100 - 64) * progress,
            inputToToggles: 80 - (80 - 64) * progress,
            toggles: 16 - (16 - 8) * progress
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main content area
                VStack {
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 0) {
                        Text("Welcome Back!")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.appTextPrimary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 24)
                        
                        Spacer().frame(height: spacingValues.headerToInput)
                        
                        VStack(spacing: 16) {
                            InputField(
                                label: "Phone Number, Email, or Employee ID",
                                placeholder: "Phone Number, email, or EID",
                                text: $identifier
                            )
                            .focused($isInputFieldFocused)
                            
                            CustomButton(title: "Next") {
                                isInputFieldFocused = false
                            }
                        }
                        
                        Spacer().frame(height: spacingValues.inputToToggles)
                        
                        VStack(spacing: spacingValues.toggles) {
                            CustomToggle(
                                label: "Keep me signed in on this device",
                                isOn: $keepSignedIn
                            )
                            
                            CustomToggle(
                                label: "Enable FaceID",
                                isOn: $enableFaceID
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isInputFieldFocused = false
                }
                .frame(height: geometry.size.height - 120)
                .background(Color.clear)
                
                // Footer section
                VStack(spacing: 8) {
                    CustomButton(
                        title: "Sign in with SSO",
                        type: .secondary,
                        leftIcon: Image(systemName: "key.fill")
                    ) {
                        isInputFieldFocused = false
                    }
                    .padding(.horizontal, 24)
                    
                    Text("© 2016-2023 Olivia by Paradox")
                        .font(.system(size: 14))
                        .foregroundColor(.appTextTertiary)
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                }
                .padding(.top, 8)
                .background(Color.clear)
            }
            .background(Color.clear)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview

#Preview {
    LoginView()
} 

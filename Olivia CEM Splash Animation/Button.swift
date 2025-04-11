import SwiftUI

// MARK: - Custom Button

struct CustomButton: View {
    enum ButtonType {
        case primary
        case secondary
    }
    
    // MARK: - Properties
    
    let title: String
    let type: ButtonType
    let action: () -> Void
    let leftIcon: Image?
    
    // MARK: - Initialization
    
    init(title: String, type: ButtonType = .primary, leftIcon: Image? = nil, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.leftIcon = leftIcon
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let leftIcon = leftIcon {
                    leftIcon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 48)
        }
        .buttonStyle(CustomButtonStyle(type: type))
    }
}

// MARK: - Custom Button Style

struct CustomButtonStyle: ButtonStyle {
    let type: CustomButton.ButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(backgroundColor(isPressed: configuration.isPressed))
            )
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(strokeColor(isPressed: configuration.isPressed), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.16), value: configuration.isPressed)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        switch (type, isPressed) {
        case (.primary, true):
            return .appPrimaryPressed
        case (.primary, false):
            return .appPrimary
        case (.secondary, true):
            return .appSecondaryPressed
        case (.secondary, false):
            return .appBackground
        }
    }
    
    private var foregroundColor: Color {
        type == .primary ? .white : .appTextSecondary
    }
    
    private func strokeColor(isPressed: Bool) -> Color {
        (type == .secondary && !isPressed) ? .appBorder : .clear
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "Next") {
            print("Primary button tapped")
        }
        
        CustomButton(title: "Sign in with SSO", type: .secondary) {
            print("Secondary button tapped")
        }
        
        CustomButton(
            title: "With Icon", 
            leftIcon: Image(systemName: "key.fill")
        ) {
            print("Button with icon tapped")
        }
    }
    .padding()
    .background(Color(white: 0.95))
} 

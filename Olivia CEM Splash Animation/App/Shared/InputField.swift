import SwiftUI

struct InputField: View {
    // MARK: - Properties
    
    let label: String
    let placeholder: String
    @Binding var text: String
    @State private var isFocused: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.appTextSecondary)
            
            TextField(placeholder, text: $text, onEditingChanged: { isEditing in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isFocused = isEditing
                }
            })
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.appTextPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .frame(height: 48)
                .background(isFocused ? Color.appInputBackgroundFocused : Color.appInputBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        InputField(
            label: "Phone Number, Email, or Employee ID",
            placeholder: "Phone Number, email, or EID",
            text: .constant("")
        )
        
        InputField(
            label: "Password",
            placeholder: "Enter your password",
            text: .constant("password123")
        )
    }
    .padding()
    .background(Color.appBackground)
} 

import SwiftUI

struct CustomToggle: View {
    // MARK: - Properties
    
    let label: String
    @Binding var isOn: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Capsule()
                    .fill(isOn ? Color.appPrimary : Color.appToggleOff)
                    .frame(width: 48, height: 32)
                
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 28, height: 28)
                    .offset(x: isOn ? 8 : -8)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.2)) {
                    isOn.toggle()
                }
            }
            
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.appToggleText)
            
            Spacer()
        }
        .frame(height: 48)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        CustomToggle(
            label: "Keep me signed in on this device", 
            isOn: .constant(true)
        )
        
        CustomToggle(
            label: "Enable FaceID", 
            isOn: .constant(false)
        )
    }
    .padding()
    .background(Color.appBackground)
} 

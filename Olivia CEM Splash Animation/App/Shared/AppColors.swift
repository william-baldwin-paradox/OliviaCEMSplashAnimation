import SwiftUI

struct AppColors {
    // Primary colors
    static let primary = Color(red: 0.145, green: 0.788, blue: 0.816)  // Teal
    static let primaryPressed = Color(hex: "0BB4BA")
    
    // Text colors
    static let textPrimary = Color(hex: "555555") // Dark gray instead of black
    static let textSecondary = Color(red: 0.333, green: 0.333, blue: 0.333)
    static let textTertiary = Color(red: 0.663, green: 0.663, blue: 0.663)
    static let toggleText = Color(hex: "A9A9A9")
    
    // Background colors
    static let background = Color.white
    static let inputBackground = Color(red: 0.973, green: 0.973, blue: 0.973)
    static let inputBackgroundFocused = Color(hex: "EDEDED")
    static let secondaryPressed = Color(hex: "F8F8F8")
    
    // Border colors
    static let border = Color(red: 0.855, green: 0.863, blue: 0.878)
    
    // Toggle colors
    static let toggleOff = Color(red: 0.663, green: 0.663, blue: 0.663)
}

// Extension to make colors easily accessible in SwiftUI
extension Color {
    static let appPrimary = AppColors.primary
    static let appPrimaryPressed = AppColors.primaryPressed
    static let appTextPrimary = AppColors.textPrimary
    static let appTextSecondary = AppColors.textSecondary
    static let appTextTertiary = AppColors.textTertiary
    static let appToggleText = AppColors.toggleText
    static let appBackground = AppColors.background
    static let appInputBackground = AppColors.inputBackground
    static let appInputBackgroundFocused = AppColors.inputBackgroundFocused
    static let appSecondaryPressed = AppColors.secondaryPressed
    static let appBorder = AppColors.border
    static let appToggleOff = AppColors.toggleOff
    
    // Helper to create colors from hex values
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 

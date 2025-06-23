import Foundation
import CoreGraphics
import UIKit

// MARK: - Device Dimensions
class DeviceDimensions: ObservableObject {
    static let shared = DeviceDimensions()
    
    @Published var screenWidth: CGFloat
    @Published var screenHeight: CGFloat
    @Published var safeAreaTop: CGFloat
    @Published var safeAreaBottom: CGFloat
    
    private init() {
        let screen = UIScreen.main.bounds
        self.screenWidth = screen.width
        self.screenHeight = screen.height
        
        // Get safe area insets
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            self.safeAreaTop = window.safeAreaInsets.top
            self.safeAreaBottom = window.safeAreaInsets.bottom
        } else {
            // Fallback values
            self.safeAreaTop = 44
            self.safeAreaBottom = 34
        }
        
        print("📱 Device Dimensions - Width: \(screenWidth), Height: \(screenHeight)")
        print("🔒 Safe Areas - Top: \(safeAreaTop), Bottom: \(safeAreaBottom)")
    }
    
    // Preview/Debug values
    static let previewWidth: CGFloat = 393
    static let previewHeight: CGFloat = 852
    static let previewSafeAreaTop: CGFloat = 59
    static let previewSafeAreaBottom: CGFloat = 34
}

// MARK: - Lottie Configuration
enum LottieConfig {
    static let fileName = "olivia-splash-login-lottie_1.1"  // Will try both .json and .lottie
    
    // Animation segments based on the actual Lottie file v1.1
    static let splashSegment = LottieSegment(startFrame: 0, endFrame: 207)   // Splash: frames 0-207
    static let loginSegment = LottieSegment(startFrame: 208, endFrame: 285)  // Login: frames 208-285
}

// MARK: - Animation Constants
enum AnimationConstants {
    static let minimumLoadTime: TimeInterval = 1.0
    static let progressSpringResponse: TimeInterval = 0.45
    static let springDamping: CGFloat = 0.7
    
    // Lottie sizing
    static let collapsedHeight: CGFloat = 120
    
    // Lottie playback speeds - now separated by segment
    static let splashPlaybackSpeed: CGFloat = 1.125      // Normal speed for splash
    static let loginPlaybackSpeed: CGFloat = 1.1       // 50% faster for login segment
    
    // Timing delays
    static let loginUIDelay: TimeInterval = 0.0         // Delay before showing login UI
    static let loginLottieDelay: TimeInterval = 0.36     // Additional delay before starting login Lottie segment
    
    // Legacy support - can be removed if not used elsewhere
    static let lottiePlaybackSpeed: CGFloat = 1.125
}

// MARK: - Layout Constants
enum LayoutConstants {
    static let loginViewMaxWidth: CGFloat = 393
}

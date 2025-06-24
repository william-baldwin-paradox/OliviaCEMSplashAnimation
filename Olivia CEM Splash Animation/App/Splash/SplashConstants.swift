import Foundation
import CoreGraphics

// MARK: - Lottie Configuration
enum LottieConfig {
    static let fileName = "olivia-splash-login-lottie_1.6"  // Will try both .json and .lottie
    
    // Animation segments based on the actual Lottie file v1.3
    static let splashSegment = LottieSegment(startFrame: 0, endFrame: 108)   // Splash: frames 0-108
    static let loginSegment = LottieSegment(startFrame: 109, endFrame: 137)  // Login: frames 109-137
}

// MARK: - Animation Constants
enum AnimationConstants {
    static let minimumLoadTime: TimeInterval = 1.0
    static let progressSpringResponse: TimeInterval = 0.5
    static let springDamping: CGFloat = 0.64
    
    // Lottie playback speeds - now separated by segment
    static let splashPlaybackSpeed: CGFloat = 1.1      // Normal speed for splash
    static let loginPlaybackSpeed: CGFloat = 0.9       // 50% faster for login segment
    
    // Timing delays - Lottie starts 0.2s before UI
    static let loginUIDelay: TimeInterval = 0.43         // Delay before showing login UI
    static let loginLottieDelay: TimeInterval = 0.4     // Login Lottie starts 0.2s before UI (0.6 - 0.4 = 0.2s earlier)
}

// MARK: - Layout Constants
enum LayoutConstants {
    // Max width for login view content (tablets only)
    // For phones, the view will use natural width with padding
    static let loginViewMaxWidth: CGFloat = 393
    static let horizontalPadding: CGFloat = 24
}

import Foundation
import CoreGraphics

// MARK: - Rive Identifiers
enum RiveIDs {
    static let fileName = "olivia-cem-splash-prod"
    static let artboardName = "PROD"
    static let stateMachineName = "SplashStateMachine"
    
    // Events
    static let logoDeltaEvent = "logoDelta"
    
    // Inputs
    static let initializationPercentInput = "initializationPercent"
    static let showLoginUIInput = "showLoginUI"
    
    // States
    static let loginState = "Login"
}

// MARK: - Animation Constants
enum AnimationConstants {
    static let minimumLoadTime: TimeInterval = 1.5
    static let progressSpringResponse: TimeInterval = 0.5
    static let springDamping: CGFloat = 1
}

// MARK: - Layout Constants
enum LayoutConstants {
    static let loginViewMaxWidth: CGFloat = 393
}

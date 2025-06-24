# Olivia CEM Splash Animation

A production-ready splash animation implementation using Lottie and SwiftUI with sophisticated timing controls and responsive design.

## Architecture

The project follows MVVM architecture with clear separation of concerns:

```
OliviaCEMSplashAnimation/
│
├── App/
│   ├── Splash/
│   │   ├── SplashView.swift         # Main splash screen with overlay system
│   │   ├── SplashViewModel.swift    # Animation state management & sequencing
│   │   └── SplashConstants.swift    # Configuration constants & timing
│   ├── Login/
│   │   └── LoginView.swift          # Login UI with proportional spacing
│   └── Shared/
│       ├── LottieView.swift         # Lottie animation wrapper
│       ├── Button.swift             # Custom button components
│       ├── CustomToggle.swift       # Toggle components
│       ├── InputField.swift         # Input field components
│       └── AppColors.swift          # Color system
│
└── Resources/
    └── Lottie/
        └── olivia-splash-login-lottie_1.6.json  # Final animation asset
```

## Key Features

### ✅ Advanced Animation System
- **Segmented Lottie playback** - Splash (frames 0-108) → Login (frames 109-137)
- **Sophisticated timing controls** - Lottie starts 0.2s before UI animation
- **State machine architecture** - Clean transitions between animation states
- **Optimized performance** - Single animation view with dynamic segments

### ✅ Responsive Design
- **Proportional spacing** - LoginView spacing scales with screen height (ratio: 4.347826087)
- **iPad optimization** - Centered 393px max width layout
- **Universal support** - Works seamlessly on all iOS devices
- **Aspect-aware scaling** - Animation scales properly with different screen sizes

### ✅ Production-Ready Architecture
- **MVVM pattern** with proper separation of concerns
- **No magic numbers** - all constants extracted to configuration files
- **Memory-safe** - proper weak references and lifecycle management
- **Thread-safe** - proper use of `@MainActor` and async operations

### ✅ Developer Experience
- **Clean codebase** - No development artifacts or test files
- **Comprehensive documentation** - Well-documented code with clear structure
- **SwiftLint ready** - Code quality standards enforced
- **Git hygiene** - .gitignore prevents development noise

## Setup Instructions

1. **Install SwiftLint** (optional but recommended):
   ```bash
   brew install swiftlint
   ```

2. **Add Lottie Dependency**:
   - In Xcode: File → Add Package Dependencies
   - URL: `https://github.com/airbnb/lottie-ios`
   - Version: Use latest stable version

3. **Configure Build Settings**:
   - Enable Thread Sanitizer (Debug only)
   - Enable Undefined Behavior Sanitizer (Debug only)

## Animation Configuration

The Lottie animation (`olivia-splash-login-lottie_1.6.json`) contains:
- **Splash Segment**: Frames 0-108 (plays at 1.1x speed)
- **Login Segment**: Frames 109-137 (plays at 0.9x speed)
- **Total Duration**: ~4.5 seconds with optimized pacing
- **Square Format**: 1:1 aspect ratio for consistent scaling

### Timing Configuration

```swift
// In SplashConstants.swift
static let loginUIDelay: TimeInterval = 0.43     // Delay before UI animation
static let loginLottieDelay: TimeInterval = 0.4  // Lottie starts 0.03s before UI
```

## Integration

### Basic Usage

The splash system works as an overlay - simply use `SplashView` as your app's initial view:

```swift
import SwiftUI

@main
struct OliviaCEMSplashApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
                .ignoresSafeArea(.all)
        }
    }
}
```

### Customization

Adjust timing and spacing in `SplashConstants.swift`:

```swift
enum AnimationConstants {
    // Adjust these values to fine-tune timing
    static let loginUIDelay: TimeInterval = 0.43         
    static let loginLottieDelay: TimeInterval = 0.4     
    
    // Adjust these for different animation speeds
    static let splashPlaybackSpeed: CGFloat = 1.1      
    static let loginPlaybackSpeed: CGFloat = 0.9       
}
```

### Proportional Spacing

The LoginView automatically calculates spacing based on screen height:

```swift
// Spacing ratio based on iPhone 15 (852px height, 196px spacing)
private let spacerRatio: CGFloat = 4.347826087

// Usage: geometry.size.height / spacerRatio
```

## Testing

Test the app with different configurations:
- **Device sizes** - iPhone SE to iPhone Pro Max
- **iPad orientations** - Portrait and landscape
- **Animation timing** - Verify smooth transitions
- **Accessibility** - Test with VoiceOver enabled

## Performance Considerations

- **Single animation view** - Reuses one LottieView with dynamic segments
- **Optimized transitions** - No view recreation during segment changes
- **Memory efficient** - Proper cleanup and weak references
- **Responsive layouts** - GeometryReader only where necessary

## 📋 Key Improvements

This implementation provides significant improvements over previous versions:

### Animation System
- ✅ **Segmented playback** replaces complex state management
- ✅ **Precise timing control** with configurable delays
- ✅ **Single source of truth** for animation state

### Layout & Spacing
- ✅ **Proportional spacing** prevents overlap issues across devices
- ✅ **iPad centering** with proper horizontal layout
- ✅ **Responsive design** that scales with screen dimensions

### Code Quality
- ✅ **Clean architecture** with clear separation of concerns
- ✅ **No magic numbers** - all values are configurable constants
- ✅ **Production ready** - no debug artifacts or test files

## 🚨 Troubleshooting

- **Animation not loading**: Verify `olivia-splash-login-lottie_1.6.json` is in bundle
- **Timing issues**: Adjust `loginUIDelay` and `loginLottieDelay` in constants
- **Spacing problems**: Modify `spacerRatio` for different proportions
- **iPad layout**: Check horizontal centering with 393px max width

## 🔧 Configuration Reference

### Animation Segments
```swift
static let splashSegment = LottieSegment(startFrame: 0, endFrame: 108)
static let loginSegment = LottieSegment(startFrame: 109, endFrame: 137)
```

### Timing Controls
```swift
static let loginUIDelay: TimeInterval = 0.43      // UI animation delay
static let loginLottieDelay: TimeInterval = 0.4   // Lottie animation delay
```

### Layout Constants
```swift
static let loginViewMaxWidth: CGFloat = 393        // iPad max width
static let horizontalPadding: CGFloat = 24         // Standard padding
```

## Dependencies

- **Lottie-iOS** - Latest stable version for animation playback
- **SwiftUI** - iOS 17.0+ for modern layout system
- **Foundation** - Core system functionality

---

**Note**: This implementation uses Lottie instead of Rive for improved performance and easier maintenance. All timing and spacing have been optimized for production use.

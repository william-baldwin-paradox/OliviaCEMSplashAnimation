# Olivia CEM Splash Animation

A production-ready splash animation implementation using Rive and SwiftUI.

## Architecture

The project follows MVVM architecture with clear separation of concerns:

```
OliviaCEMSplashAnimation/
│
├── App/
│   ├── Splash/
│   │   ├── SplashView.swift         # Main splash screen view
│   │   ├── SplashViewModel.swift    # Business logic and state management
│   │   └── SplashConstants.swift    # All constants and magic numbers
│   ├── Login/
│   │   └── LoginView.swift          # Login UI implementation
│   └── Shared/
│       ├── AnimationProgressEnvironment.swift
│       ├── Button.swift
│       ├── CustomToggle.swift
│       ├── InputField.swift
│       └── AppColors.swift
│
└── Resources/
    ├── Rive/
    │   └── olivia-cem-splash-prod.riv
    └── Assets.xcassets
```

## Key Features

### ✅ Production-Ready Architecture
- **MVVM pattern** with proper separation of concerns
- **No magic numbers** - all constants extracted to `SplashConstants.swift`
- **Memory-safe** - proper weak references in delegates to prevent retain cycles
- **Thread-safe** - proper use of `@MainActor` and `Task`

### ✅ Error Handling
- Graceful fallback when Rive fails to load
- Logging with `os.log` for debugging
- User-friendly error UI with skip option

### ✅ Accessibility & UX
- **Dark mode support** - uses system background colors
- **VoiceOver ready** - proper accessibility traits and modal handling
- **Reduce Motion** respected via SwiftUI animations

### ✅ Developer Experience
- **SwiftLint** configuration for code quality
- **Pinned dependencies** - Rive runtime locked to v6.7.4
- **Well-documented** code with MARK sections
- **Multiple previews** for different states

## Setup Instructions

1. **Install SwiftLint** (optional but recommended):
   ```bash
   brew install swiftlint
   ```

2. **Add SwiftLint Build Phase**:
   - Select project in Xcode
   - Select target → Build Phases
   - Add New Run Script Phase:
   ```bash
   if which swiftlint >/dev/null; then
     swiftlint
   else
     echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
   fi
   ```

3. **Configure Build Settings**:
   - Enable Thread Sanitizer (Debug only)
   - Enable Undefined Behavior Sanitizer (Debug only)

## State Machine Integration

The Rive file (`olivia-cem-splash-prod.riv`) contains:
- **Artboard**: "PROD"
- **State Machine**: "SplashStateMachine"
- **Event**: "logoDelta" - fires when logo animation reaches the login position
- **Input**: "initializationPercent" - controls buffer progress (0-100)

## Testing

Run the app with different configurations:
- Light/Dark mode
- Different device sizes
- With/without network (to test error state)
- With VoiceOver enabled

## Maintenance

When updating animations:
1. Update event/input names in `SplashConstants.swift`
2. Test all transitions thoroughly
3. Verify accessibility still works

## Dependencies

- **RiveRuntime** v6.7.4 - Pinned for stability
- **SwiftUI** - iOS 17.0+

## Performance Considerations

- Rive view is hidden from accessibility tree to prevent focus issues
- Animations use native SwiftUI for better performance
- Proper cancellation of async tasks prevents memory leaks

## 📋 Overview

This component provides a smooth, production-ready splash to login transition using Rive animations that:

- Shows a custom splash animation while the app initializes
- Smoothly transitions to a login UI when ready
- Supports both iPhone and iPad devices
- Automatically handles orientation (iPad is locked to landscape)
- Includes fallback mechanisms if animation events don't fire

## 🛠️ Integration Steps

### 1. Add Required Files to Your Project

Add these files to your project:
- `SplashView.swift`
- `SplashViewModel.swift`
- `olivia-cem-splash-prod.riv` (Rive animation file)

### 2. Add the Rive Runtime Dependency

#### Option A: Using Swift Package Manager (Recommended)
1. In Xcode, go to File > Add Package Dependencies...
2. Enter the URL: `https://github.com/rive-app/rive-ios`
3. Select "Up to Next Major Version" (3.0.0 < 4.0.0)

#### Option B: Using the XCFramework
1. Add the `RiveRuntime.xcframework` to your project

### 3. Use the SplashView in Your App

```swift
import SwiftUI
import RiveRuntime

struct MyAppEntryView: View {
    var body: some View {
        SplashView(
            // Optional: Configure animation settings
            config: .defaultConfig,
            
            // Called when splash animation completes and login is visible
            onSplashComplete: {
                // Handle navigation or other post-splash actions
                print("Splash animation complete!")
            }
        ) {
            // Your existing login UI goes here - will be animated in
            YourLoginView()
        }
    }
}
```

### 4. [Optional] Update Initialization Progress

If you want to tie the animation to your app's actual loading progress:

```swift
// Get a reference to your SplashViewModel
@StateObject private var splashViewModel = SplashViewModel()

// Pass it to SplashView
SplashView(viewModel: splashViewModel) {
    YourLoginView() 
}

// Update progress during app initialization (0-100)
func updateLoadingProgress() {
    // When database loads
    splashViewModel.updateInitializationProgress(25) 
    
    // When network requests complete
    splashViewModel.updateInitializationProgress(50)
    
    // When app is fully initialized
    splashViewModel.updateInitializationProgress(100)
}
```

### 5. Access the Animation Progress in Your Login UI (Optional)

The login view can access the animation progress via an environment value:

```swift
struct YourLoginView: View {
    @Environment(\.animationProgressKey) var animationProgress
    
    var body: some View {
        VStack {
            // Use animationProgress to coordinate additional animations
            Text("Login")
                .opacity(animationProgress)
        }
    }
}
```

## ⚙️ Configuration Options

All animation parameters are configurable via the `SplashConfig` struct:

```swift
// Example: Custom configuration
let customConfig = SplashConfig(
    riveFileName: "your-custom-animation",
    stateMachineName: "CustomStateMachine",
    artboardName: "PHONE",
    tabletArtboardName: "TABLET",
    initializationInputName: "loadingProgress",
    logoTransitionEventName: "showLogin",
    minimumLoadTime: 2.0,
    fallbackTimeout: 5.0
)

// Pass to SplashView
SplashView(config: customConfig, onSplashComplete: nil) {
    YourLoginView()
}
```

## 🚨 Troubleshooting

- **Rive Animation Not Appearing**: Ensure the .riv file is included in your app bundle
- **Login Never Appears**: Check logs for warnings about the animation event not firing
- **iPad Display Issues**: The component forces landscape orientation on iPads by default

## 📝 Notes for Developers

- The splash component automatically handles portrait/landscape for iPad/iPhone
- To see debug logs, filter Console app for subsystem "YOUR_BUNDLE_ID" and category "SplashViewModel"
- If animation fails to load, a fallback UI will be shown 
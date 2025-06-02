# Olivia CEM Splash Animation

A code-fidelity prototype for splash animation implementation using Rive and SwiftUI.

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

`SplashView` only needs the device's top safe-area inset so that, once collapsed, the animation header tucks neatly under the status-bar.

```swift
import SwiftUI

struct MyAppEntryView: View {
    var body: some View {
        // Forward the safe-area inset via GeometryReader
        GeometryReader { geo in
            SplashView(topSafeArea: geo.safeAreaInsets.top)
                .ignoresSafeArea() // Splash covers the whole window
        }
    }
}
```

The component will automatically:

1. Play the Rive splash while your app finishes loading.
2. Animate the bundled `LoginView` into place when the animation event `logoDelta` fires.
3. Handle dark-mode, accessibility and layout for both iPhone and iPad — out of the box.

No additional configuration is required; the IDs in `SplashConstants.swift` already match the bundled `.riv` file.

## 🚨 Troubleshooting

- **Rive Animation Not Appearing**: Ensure the .riv file is included in your app bundle
- **Login Never Appears**: Check logs for warnings about the animation event not firing
- **iPad Display Issues**: The component forces landscape orientation on iPads by default

## 📝 Notes for Developers

- The splash component automatically handles portrait/landscape for iPad/iPhone
- To see debug logs, filter Console app for subsystem "YOUR_BUNDLE_ID" and category "SplashViewModel"
- If animation fails to load, a fallback UI will be shown 

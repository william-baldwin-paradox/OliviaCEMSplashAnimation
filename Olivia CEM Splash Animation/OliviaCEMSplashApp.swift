import SwiftUI
import UIKit

// iOS 14+ App Structure
@available(iOS 14.0, *)
@main
struct OliviaCEMSplashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Shared ContentView that works across iOS versions
struct ContentView: View {
    @ObservedObject private var deviceDimensions = DeviceDimensions.shared
    
    var body: some View {
        GeometryReader { geometry in
            SplashView(topSafeArea: geometry.safeAreaInsets.top)
                .onAppear {
                    // Ensure DeviceDimensions is initialized with current values
                    print("📱 ContentView: Initializing device dimensions")
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// iOS 13 Entry Point - Using UIApplicationMain
#if !os(macOS)
@available(iOS 13.0, *)
extension AppDelegate {
    static func main() {
        if #available(iOS 14.0, *) {
            // iOS 14+ will use the @main App structure above
            return
        } else {
            // iOS 13 will use traditional UIApplicationMain
            UIApplicationMain(
                CommandLine.argc,
                CommandLine.unsafeArgv,
                nil,
                NSStringFromClass(AppDelegate.self)
            )
        }
    }
}
#endif

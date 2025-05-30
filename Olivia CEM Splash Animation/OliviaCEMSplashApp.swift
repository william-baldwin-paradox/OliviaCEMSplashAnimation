import SwiftUI

@main
struct OliviaCEMSplashApp: App {
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                SplashView(topSafeArea: geometry.safeAreaInsets.top)
            }
        }
    }
}

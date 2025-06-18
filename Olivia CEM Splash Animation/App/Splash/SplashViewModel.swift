import SwiftUI

// MARK: - SplashViewModel
@MainActor
final class SplashViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var showLoginUI = false
    @Published var currentAnimationState: AnimationState = .splash
    
    // MARK: - Animation State
    enum AnimationState {
        case splash        // Playing the splash segment (0-207)
        case pausedAtLogin // Paused at frame 207, showing login UI
        case login         // Playing the login segment (208-285)
        case completed     // Paused at final frame 285
    }
    
    // MARK: - Private Properties
    private var hasHandledSplashCompletion = false
    private var hasHandledLoginCompletion = false
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - Public Methods
    func start() {
        print("🚀 SplashViewModel: Starting splash sequence")
        currentAnimationState = .splash
    }
    
    func startImmediately() {
        print("🚀 SplashViewModel: Starting splash sequence immediately (preview mode)")
        currentAnimationState = .splash
    }
    
    func lottieView() -> some View {
        // Single continuous animation view that handles all segments
        LottieView(
            animationName: LottieConfig.fileName,
            loopMode: .playOnce,
            segment: currentSegment(),
            completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.handleAnimationCompletion()
                }
            }
        )
        .id("continuous-lottie-animation") // Single stable ID
        .onAppear {
            print("🔄 Continuous LottieView appeared with state: \(self.currentAnimationState)")
        }
    }
    
    // MARK: - Private Methods
    private func currentSegment() -> LottieSegment? {
        switch currentAnimationState {
        case .splash:
            print("🎯 Playing splash segment (0-207)")
            return LottieConfig.splashSegment
            
        case .pausedAtLogin:
            print("🎯 Paused at login transition (frame 207)")
            return nil // Will pause the animation
            
        case .login:
            print("🎯 Playing login segment (208-285)")
            return LottieConfig.loginSegment
            
        case .completed:
            print("🎯 Animation completed, paused at final frame (285)")
            return nil // Will stay paused at final frame
        }
    }
    
    private func handleAnimationCompletion() {
        switch currentAnimationState {
        case .splash:
            handleSplashCompletion()
        case .login:
            handleLoginCompletion()
        case .pausedAtLogin, .completed:
            // These states don't have completion callbacks
            break
        }
    }
    
    private func handleSplashCompletion() {
        guard !hasHandledSplashCompletion else {
            print("⚠️ Splash completion already handled, ignoring")
            return
        }
        hasHandledSplashCompletion = true
        
        print("🎬 Splash segment completed, pausing and starting synchronized animations")
        
        // Pause at frame 207
        currentAnimationState = .pausedAtLogin
        
        // Start login UI first, then follow with Lottie login segment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("🎭 Starting login UI animation")
            
            // Start login UI animation first
            withAnimation(.spring(response: AnimationConstants.progressSpringResponse, dampingFraction: AnimationConstants.springDamping)) {
                self.showLoginUI = true
            }
            
            // Start login segment slightly after the UI animation begins
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                print("🎬 Starting login Lottie segment (delayed)")
                self.currentAnimationState = .login
            }
        }
    }
    
    private func handleLoginCompletion() {
        guard !hasHandledLoginCompletion else {
            print("⚠️ Login completion already handled, ignoring")
            return
        }
        hasHandledLoginCompletion = true
        
        print("✅ Login segment completed, pausing at final frame")
        
        // Stay paused at the final frame (285) which contains the logo
        currentAnimationState = .completed
    }
} 

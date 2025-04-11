import SwiftUI
import RiveRuntime

struct ContentView: View {
    // MARK: - Properties
    
    @StateObject private var riveViewModel = RiveViewModel(
        fileName: "olivia-cem-splash-prod",
        stateMachineName: "SplashStateMachine", 
        fit: .cover,
        autoPlay: true,
        artboardName: "PROD"
    )
    
    @State private var showLoginUI = false
    @State private var animationProgress: CGFloat = 0
    @State private var loginViewOpacity: Double = 0
    @State private var loginViewOffset: CGFloat = 200
    @State private var inputDelegate: CustomRiveDelegate?
    
    private let minimumLoadTime = 1.5
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()
                
                riveViewModel.view()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    .edgesIgnoringSafeArea(.all)
                
                if showLoginUI {
                    VStack {
                        LoginView()
                            .withAnimationProgress(animationProgress)
                    }
                    .background(Color.clear)
                    .opacity(loginViewOpacity)
                    .offset(y: loginViewOffset)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.async {
                setupRiveAnimation()
            }
        }
    }
    
    // MARK: - Methods
    
    private func setupRiveAnimation() {
        guard let riveView = riveViewModel.riveView else { return }
        
        inputDelegate = CustomRiveDelegate { eventName in
            DispatchQueue.main.async {
                if eventName == "logoDelta" {
                    showLoginView()
                }
            }
        }
        
        riveView.stateMachineDelegate = inputDelegate
        
        // Initialize animation at 0%
        riveViewModel.setInput("initializationPercent", value: 0.0)
        
        // After minimum load time, set to 100% to start the animation sequence
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumLoadTime) {
            riveViewModel.setInput("initializationPercent", value: 100.0)
        }
    }
    
    private func showLoginView() {
        // Make login UI visible but initially off-screen
        showLoginUI = true
        loginViewOpacity = 0
        loginViewOffset = 200
        animationProgress = 0
        
        // Short delay to ensure UI is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            // Fade in
            withAnimation(.easeIn(duration: 0.15)) {
                loginViewOpacity = 1.0
            }
            
            // Slide up
            withAnimation(.spring(response: 0.4, dampingFraction: 0.80)) {
                loginViewOffset = 0
            }
            
            // Adjust spacing
            withAnimation(.spring(response: 0.5, dampingFraction: 0.80)) {
                animationProgress = 1.0
            }
        }
    }
}

// MARK: - Extensions

extension LoginView {
    func withAnimationProgress(_ progress: CGFloat) -> some View {
        self.environment(\.animationProgressKey, progress)
    }
}

struct AnimationProgressKey: EnvironmentKey {
    static let defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    var animationProgressKey: CGFloat {
        get { self[AnimationProgressKey.self] }
        set { self[AnimationProgressKey.self] = newValue }
    }
}

// MARK: - Custom Delegate

class CustomRiveDelegate: NSObject, RiveStateMachineDelegate {
    private var onEvent: (String) -> Void
    
    init(eventHandler: @escaping (String) -> Void) {
        self.onEvent = eventHandler
        super.init()
    }
    
    @objc func onRiveEventReceived(onRiveEvent riveEvent: RiveEvent) {
        onEvent(riveEvent.name())
    }
    
    @objc func stateMachine(_ stateMachine: RiveStateMachineInstance, didChangeState stateName: String) {
        // Required by protocol
    }
}

#Preview {
    ContentView()
} 

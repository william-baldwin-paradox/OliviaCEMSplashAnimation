import SwiftUI
import RiveRuntime
import os.log

// MARK: - SplashViewModel
@MainActor
final class SplashViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var showLoginUI = false
    
    // MARK: - Private Properties
    private let riveViewModel: RiveViewModel
    private var riveDelegate: SplashRiveDelegate?
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "OliviaCEM", 
                               category: "SplashViewModel")
    
    // MARK: - Initialization
    init() {
        self.riveViewModel = RiveViewModel(
            fileName: RiveIDs.fileName,
            stateMachineName: RiveIDs.stateMachineName,
            fit: .layout,
            autoPlay: true,
            artboardName: RiveIDs.artboardName
        )
    }
    
    // MARK: - Public Methods
    func start() {
        setupRiveAnimation()
    }
    
    func riveView() -> some View {
        riveViewModel.view()
    }
    
    // MARK: - Private Methods
    private func setupRiveAnimation() {
        guard let riveView = riveViewModel.riveView else {
            logger.error("Failed to load Rive view")
            return
        }
        
        // Create delegate with weak self to avoid retain cycles
        riveDelegate = SplashRiveDelegate { [weak self] eventName in
            guard let self = self else { return }
            
            Task { @MainActor in
                if eventName == RiveIDs.logoDeltaEvent {
                    self.showLoginView()
                }
            }
        }
        
        riveView.stateMachineDelegate = riveDelegate
        
        // Initialize animation at 0%
        riveViewModel.setInput(RiveIDs.initializationPercentInput, value: 0.0)
        
        // After minimum load time, set to 100% to start the animation sequence
        Task {
            try? await Task.sleep(nanoseconds: UInt64(AnimationConstants.minimumLoadTime * 1_000_000_000))
            
            guard !Task.isCancelled else { return }
            
            riveViewModel.setInput(RiveIDs.initializationPercentInput, value: 100.0)
        }
    }
    
    private func showLoginView() {
        // Simply toggle the flag; SwiftUI handles the animations via transitions.
        showLoginUI = true
    }
}

// MARK: - SplashRiveDelegate
final class SplashRiveDelegate: NSObject, RiveStateMachineDelegate {
    private let onEvent: (String) -> Void
    
    init(eventHandler: @escaping (String) -> Void) {
        self.onEvent = eventHandler
        super.init()
    }
    
    @objc func onRiveEventReceived(onRiveEvent riveEvent: RiveEvent) {
        onEvent(riveEvent.name())
    }
    
    @objc func stateMachine(_ stateMachine: RiveStateMachineInstance, didChangeState stateName: String) {
        // Optional: Could also trigger based on state changes
        // if stateName == RiveIDs.loginState { onEvent(RiveIDs.loginState) }
    }
} 

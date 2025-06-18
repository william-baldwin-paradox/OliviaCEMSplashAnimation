import SwiftUI

struct SplashView: View {
    // MARK: - Properties
    let topSafeArea: CGFloat
    @ObservedObject private var viewModel: SplashViewModel
    @ObservedObject private var deviceDimensions = DeviceDimensions.shared
    
    // MARK: - Initializers
    init(topSafeArea: CGFloat) {
        self.topSafeArea = topSafeArea
        self.viewModel = SplashViewModel()
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lottie Animation Container
                ZStack {
                    // Center the Lottie view with fixed dimensions
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            viewModel.lottieView()
                                .frame(
                                    width: deviceDimensions.screenWidth,
                                    height: animationHeight()
                                )
                                .clipped()
                            
                            Spacer()
                        }
                        
                        if viewModel.showLoginUI {
                            Spacer()
                        }
                    }
                }
                .frame(
                    width: deviceDimensions.screenWidth,
                    height: containerHeight()
                )
                .background(Color.clear)
                
                // Login UI Container
                if viewModel.showLoginUI {
                    VStack {
                        LoginView()
                            .frame(maxWidth: LayoutConstants.loginViewMaxWidth)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                )
                            )
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .animation(
                .spring(response: AnimationConstants.progressSpringResponse,
                        dampingFraction: AnimationConstants.springDamping),
                value: viewModel.currentAnimationState
            )
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.start()
        }
    }
    
    // MARK: - Helper Methods
    private func animationHeight() -> CGFloat {
        // Use consistent height throughout all stages
        return deviceDimensions.screenHeight
    }
    
    private func containerHeight() -> CGFloat {
        switch viewModel.currentAnimationState {
        case .splash, .pausedAtLogin:
            // Full height during splash and pause
            return deviceDimensions.screenHeight
        case .login, .completed:
            // Header height + safe area when login UI is showing
            return topSafeArea + AnimationConstants.collapsedHeight
        }
    }
}

// MARK: - Preview
#Preview("Splash") {
    PreviewSplashView()
}

// Helper view for previews that ensures animation starts
private struct PreviewSplashView: View {
    @ObservedObject private var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Lottie Animation Container
                ZStack {
                    // Center the Lottie view with fixed dimensions
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            viewModel.lottieView()
                                .frame(
                                    width: DeviceDimensions.previewWidth,
                                    height: previewAnimationHeight()
                                )
                                .clipped()
                            
                            Spacer()
                        }
                        
                        if viewModel.showLoginUI {
                            Spacer()
                        }
                    }
                }
                .frame(
                    width: DeviceDimensions.previewWidth,
                    height: previewContainerHeight()
                )
                .background(Color.clear)
                
                // Login UI Container
                if viewModel.showLoginUI {
                    VStack {
                        LoginView()
                            .frame(maxWidth: LayoutConstants.loginViewMaxWidth)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                )
                            )
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .animation(
                .spring(response: AnimationConstants.progressSpringResponse,
                        dampingFraction: AnimationConstants.springDamping),
                value: viewModel.currentAnimationState
            )
        }
        .onAppear {
            // Start immediately for preview without delay
            viewModel.startImmediately()
        }
    }
    
    // MARK: - Helper Methods
    private func previewAnimationHeight() -> CGFloat {
        // Use consistent height throughout all stages
        return DeviceDimensions.previewHeight
    }
    
    private func previewContainerHeight() -> CGFloat {
        switch viewModel.currentAnimationState {
        case .splash, .pausedAtLogin:
            return DeviceDimensions.previewHeight
        case .login, .completed:
            return DeviceDimensions.previewSafeAreaTop + AnimationConstants.collapsedHeight
        }
    }
}

import SwiftUI

struct SplashView: View {
    // MARK: - Properties
    @ObservedObject private var viewModel: SplashViewModel
    
    // MARK: - Initializers
    init() {
        self.viewModel = SplashViewModel()
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Lottie Animation - Centered with aspect fit
                viewModel.lottieView()
                    .edgesIgnoringSafeArea(.all)
                
                // Login UI Container - Overlaid on top of the Lottie animation
                if viewModel.showLoginUI {
                    LoginView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom)
                                    .combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                        .animation(
                            .spring(
                                response: AnimationConstants.progressSpringResponse,
                                dampingFraction: AnimationConstants.springDamping
                            ),
                            value: viewModel.showLoginUI
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.start()
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
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                // Lottie Animation - Centered with aspect fit
                viewModel.lottieView()
                    .edgesIgnoringSafeArea(.all)
                
                // Login UI Container - Overlaid on top of the Lottie animation
                if viewModel.showLoginUI {
                    LoginView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom)
                                    .combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                        .animation(
                            .spring(
                                response: AnimationConstants.progressSpringResponse,
                                dampingFraction: AnimationConstants.springDamping
                            ),
                            value: viewModel.showLoginUI
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Start immediately for preview without delay
            viewModel.startImmediately()
        }
    }
}

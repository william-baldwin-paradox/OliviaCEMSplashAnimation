import SwiftUI
import RiveRuntime

struct SplashView: View {
    // MARK: - Properties
    let topSafeArea: CGFloat
    @StateObject private var viewModel = SplashViewModel()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            GeometryReader { geometry in
                // Calculate header & login heights based on whether the Login UI is showing
                let riveCollapsedHeight = viewModel.showLoginUI ? 86 : geometry.size.height
                let headerHeight = viewModel.showLoginUI ? topSafeArea + riveCollapsedHeight : geometry.size.height
                let loginHeight = max(0, geometry.size.height - headerHeight)

                VStack(spacing: 0) {
                    // Rive animation header
                    VStack(spacing: 0) {
                        viewModel.riveView()
                            .frame(maxWidth: .infinity)
                            .frame(height: riveCollapsedHeight)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .accessibilityHidden(true)
                            .background(Color.clear)
                    }
                    .frame(height: headerHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    

                    // Login UI (fills the rest of the space)
                    if viewModel.showLoginUI {
                        LoginView()
                            .frame(maxWidth: LayoutConstants.loginViewMaxWidth)
                            .frame(height: loginHeight)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                )
                            )
                    }
                }
                // Animate layout & transitions whenever showLoginUI changes
                .animation(
                    .spring(response: AnimationConstants.progressSpringResponse,
                            dampingFraction: AnimationConstants.springDamping),
                    value: viewModel.showLoginUI
                )
            }
            
        }
        .ignoresSafeArea()
        .task {
            viewModel.start()
        }
    }
}

// MARK: - Preview
#Preview("Splash") {
    SplashView(topSafeArea: 50) // Typical iPhone notch
}

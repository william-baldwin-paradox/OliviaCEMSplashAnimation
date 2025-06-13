import SwiftUI
import Lottie

/// A lightweight SwiftUI wrapper around `LottieAnimationView` that plays a bundled `.lottie` or `.json` file once and notifies when finished.
struct LottieView: UIViewRepresentable {
    /// Name of the animation file without extension (e.g. "olivia-splash-vector").
    let animationName: String
    /// Whether the animation should loop. Default is `.playOnce`.
    var loopMode: LottieLoopMode = .playOnce
    /// Callback executed on the main thread when the animation completes successfully.
    var completion: (() -> Void)?

    func makeUIView(context: Context) -> LottieAnimationView {
        // Use a nil animation on init so we can configure before playing.
        let view = LottieAnimationView()

        // Load `.lottie` (archive) or `.json` resource.
        view.animation = LottieAnimation.named(animationName)

        view.contentMode = .scaleAspectFit
        view.loopMode = loopMode
        view.backgroundBehavior = .pauseAndRestore // Respect app lifecycle (e.g. going to background)
        return view
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        guard !uiView.isAnimationPlaying else { return }

        uiView.play { finished in
            if finished {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
} 
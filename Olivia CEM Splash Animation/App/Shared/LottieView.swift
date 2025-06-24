import SwiftUI
import Lottie

/// Interactive Lottie Animation Viewer with Scrubbing Controls
struct LottieAnalysisView: View {
    @State private var currentFrame: Double = 0
    @State private var isPlaying: Bool = false
    @State private var animationView: LottieAnimationView?
    @State private var totalFrames: Double = 0
    @State private var framerate: Double = 30
    @State private var animationLoaded: Bool = false
    
    private let animationName = "olivia-splash-login-lottie_1.5"
    
    var body: some View {
        VStack(spacing: 20) {
            // Animation Display
            if animationLoaded {
                AnimationViewRepresentable(
                    animationName: animationName,
                    currentFrame: $currentFrame,
                    isPlaying: $isPlaying,
                    totalFrames: $totalFrames,
                    framerate: $framerate,
                    onAnimationViewCreated: { view in
                        self.animationView = view
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.1))
                .cornerRadius(12)
            } else {
                // Placeholder while loading or if animation fails to load
                VStack {
                    Image(systemName: "play.rectangle")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Loading Animation...")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(animationName)
                        .font(.caption)
                        .foregroundColor(Color.secondary.opacity(0.6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Controls Section
            VStack(spacing: 16) {
                // Frame Info
                HStack {
                    Text("Frame: \(Int(currentFrame))")
                        .font(.system(.body, design: .monospaced))
                    Spacer()
                    Text("Total: \(Int(totalFrames))")
                        .font(.system(.body, design: .monospaced))
                    Spacer()
                    Text("FPS: \(Int(framerate))")
                        .font(.system(.body, design: .monospaced))
                }
                .foregroundColor(.secondary)
                
                // Frame Navigation
                HStack(spacing: 20) {
                    // Step Backward
                    Button(action: stepBackward) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .disabled(currentFrame <= 0 || !animationLoaded)
                    
                    // Play/Pause
                    Button(action: togglePlayback) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .disabled(!animationLoaded)
                    
                    // Step Forward
                    Button(action: stepForward) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    .disabled(currentFrame >= totalFrames || !animationLoaded)
                }
                
                // Scrubber Slider
                VStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { currentFrame },
                            set: { newValue in
                                currentFrame = newValue
                                updateFrame()
                            }
                        ),
                        in: 0...max(totalFrames, 1),
                        step: 1,
                        onEditingChanged: { editing in
                            if editing && animationLoaded {
                                isPlaying = false
                                animationView?.pause()
                            }
                        }
                    )
                    .disabled(!animationLoaded)
                    
                    HStack {
                        Text("0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(totalFrames))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .padding()
        .onAppear {
            checkAnimationAvailability()
        }
    }
    
    private func checkAnimationAvailability() {
        // Try to load the animation to see if it's available
        if LottieAnimation.named(animationName) != nil {
            animationLoaded = true
        } else {
            print("⚠️ Animation '\(animationName)' not found in bundle")
            animationLoaded = false
        }
    }
    
    private func stepBackward() {
        guard animationLoaded else { return }
        currentFrame = max(0, currentFrame - 1)
        updateFrame()
    }
    
    private func stepForward() {
        guard animationLoaded else { return }
        currentFrame = min(totalFrames, currentFrame + 1)
        updateFrame()
    }
    
    private func togglePlayback() {
        guard animationLoaded else { return }
        isPlaying.toggle()
        
        if isPlaying {
            animationView?.play()
        } else {
            animationView?.pause()
        }
    }
    
    private func updateFrame() {
        guard animationLoaded else { return }
        animationView?.currentFrame = AnimationFrameTime(currentFrame)
    }
}

/// UIViewRepresentable for Lottie Animation
struct AnimationViewRepresentable: UIViewRepresentable {
    let animationName: String
    @Binding var currentFrame: Double
    @Binding var isPlaying: Bool
    @Binding var totalFrames: Double
    @Binding var framerate: Double
    let onAnimationViewCreated: (LottieAnimationView) -> Void
    
    func makeUIView(context: Context) -> UIView {
        // Create a container view
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let animationView = LottieAnimationView()
        
        // Load animation safely
        guard let animation = LottieAnimation.named(animationName) else {
            print("⚠️ Failed to load animation: \(animationName)")
            return containerView
        }
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.currentFrame = AnimationFrameTime(0)
        
        // Add animation view to container
        containerView.addSubview(animationView)
        
        // For square animations, we need to scale based on height
        // Set the frame to match container height and maintain aspect ratio
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Center the animation view and make it square based on container height
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: animationView.heightAnchor) // Square aspect ratio
        ])
        
        // Update binding values
        DispatchQueue.main.async {
            self.totalFrames = Double(animation.endFrame - animation.startFrame)
            self.framerate = Double(animation.framerate)
            self.currentFrame = Double(animation.startFrame)
        }
        
        // Set up coordinator
        context.coordinator.animationView = animationView
        context.coordinator.setupDisplayLink()
        
        onAnimationViewCreated(animationView)
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: AnimationViewRepresentable
        var displayLink: CADisplayLink?
        var animationView: LottieAnimationView?
        
        init(_ parent: AnimationViewRepresentable) {
            self.parent = parent
        }
        
        func setupDisplayLink() {
            // Only create display link if not already created
            guard displayLink == nil else { return }
            
            displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
            displayLink?.add(to: .main, forMode: .common)
        }
        
        @objc func updateFrame() {
            guard let animationView = animationView else { return }
            
                                DispatchQueue.main.async {
                let frameTime = animationView.currentFrame
                self.parent.currentFrame = Double(frameTime)
            }
        }
        
        deinit {
            displayLink?.invalidate()
            displayLink = nil
        }
    }
}

/// Simple Lottie View wrapper for basic usage
struct LottieView: View {
    let animationName: String
    let loopMode: LottieLoopMode
    let fromFrame: AnimationFrameTime?
    let toFrame: AnimationFrameTime?
    let completion: (() -> Void)?
    let playbackSpeed: CGFloat
    let contentMode: UIView.ContentMode
    
    init(
        animationName: String,
        loopMode: LottieLoopMode = .playOnce,
        segment: LottieSegment? = nil,
        completion: (() -> Void)? = nil,
        playbackSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.fromFrame = segment?.startFrame
        self.toFrame = segment?.endFrame
        self.completion = completion
        self.playbackSpeed = playbackSpeed
        self.contentMode = contentMode
    }
    
    var body: some View {
        LottieViewRepresentable(
            animationName: animationName,
            loopMode: loopMode,
            fromFrame: fromFrame,
            toFrame: toFrame,
            completion: completion,
            playbackSpeed: playbackSpeed,
            contentMode: contentMode
        )
    }
}

struct LottieViewRepresentable: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let fromFrame: AnimationFrameTime?
    let toFrame: AnimationFrameTime?
    let completion: (() -> Void)?
    let playbackSpeed: CGFloat
    let contentMode: UIView.ContentMode
    
    init(
        animationName: String,
        loopMode: LottieLoopMode,
        fromFrame: AnimationFrameTime? = nil,
        toFrame: AnimationFrameTime? = nil,
        completion: (() -> Void)? = nil,
        playbackSpeed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFill
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.fromFrame = fromFrame
        self.toFrame = toFrame
        self.completion = completion
        self.playbackSpeed = playbackSpeed
        self.contentMode = contentMode
    }
    
    func makeUIView(context: Context) -> UIView {
        // Create a container view
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let animationView = LottieAnimationView()
        
        // Load animation safely
        guard let animation = LottieAnimation.named(animationName) else {
            print("⚠️ Failed to load animation: \(animationName)")
            return containerView
        }
        
        animationView.animation = animation
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = playbackSpeed
        
        // Add animation view to container
        containerView.addSubview(animationView)
        
        // For square animations, we need to scale based on height
        // Set the frame to match container height and maintain aspect ratio
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        // Center the animation view and make it square based on container height
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: animationView.heightAnchor) // Square aspect ratio
        ])
        
        // Set up the coordinator to track animation state
        context.coordinator.animationView = animationView
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Find the animation view within the container
        guard let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView else { 
            return 
        }
        
        // Only proceed if animation is loaded
        guard animationView.animation != nil else { return }
        
        // Update the coordinator's parent reference
        context.coordinator.parent = self
        
        // Update playback speed
        animationView.animationSpeed = playbackSpeed
        
        // Handle animation playback based on segment
        if let fromFrame = fromFrame, let toFrame = toFrame {
            // We have a specific segment to play
            let currentSegment = "\(fromFrame)-\(toFrame)"
            
            // Only play if we haven't already played this segment or if animation isn't running
            if context.coordinator.lastPlayedSegment != currentSegment || !animationView.isAnimationPlaying {
                context.coordinator.lastPlayedSegment = currentSegment
                print("🎮 Starting animation segment: \(currentSegment)")
                
                if let completion = completion {
                    animationView.play(fromFrame: fromFrame, toFrame: toFrame) { finished in
                        if finished {
                            print("✅ Animation segment \(currentSegment) completed")
                            DispatchQueue.main.async {
                                completion()
                            }
                        }
                    }
                } else {
                    animationView.play(fromFrame: fromFrame, toFrame: toFrame)
                }
            }
        } else {
            // No segment specified - this means we should pause/stop
            if animationView.isAnimationPlaying {
                print("⏸️ Pausing animation (no segment specified)")
                animationView.pause()
            }
            context.coordinator.lastPlayedSegment = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: LottieViewRepresentable
        var animationView: LottieAnimationView?
        var lastPlayedSegment: String? // Track the last played segment to prevent re-triggering
        
        init(_ parent: LottieViewRepresentable) {
            self.parent = parent
        }
    }
}

/// Represents a segment of a Lottie animation defined by frame range
struct LottieSegment {
    let startFrame: AnimationFrameTime
    let endFrame: AnimationFrameTime
    
    init(startFrame: Double, endFrame: Double) {
        self.startFrame = AnimationFrameTime(startFrame)
        self.endFrame = AnimationFrameTime(endFrame)
    }
}

// MARK: - Preview
#Preview {
    LottieAnalysisView()
}

// MARK: - Simple Test Preview
#Preview("Simple Lottie Test") {
    VStack {
        Text("Basic Lottie View Test")
            .font(.headline)
            .padding()
        
        LottieView(
            animationName: "olivia-splash-login-lottie_1.6",
            loopMode: .loop,
            contentMode: .scaleAspectFit
        )
        .background(Color.red.opacity(0.2))
        .border(Color.blue, width: 2)
    }
    .background(Color.gray.opacity(0.1))
}

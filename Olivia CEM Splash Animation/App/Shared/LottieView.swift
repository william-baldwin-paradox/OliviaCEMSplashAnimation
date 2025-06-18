import SwiftUI
import Lottie

/// Enhanced Lottie SwiftUI implementation with comprehensive debugging
struct CustomLottieView: UIViewRepresentable {
    let animation: LottieAnimation?
    let completion: (() -> Void)?
    var playbackMode: LottiePlaybackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
    var animationSpeed: CGFloat = 1.0 // 1.0 = normal speed, 1.25 = 25% faster, 0.9 = 10% slower
    
    init(animation: LottieAnimation?, completion: (() -> Void)? = nil) {
        self.animation = animation
        self.completion = completion
    }
    
    init(animation: LottieAnimation?) {
        self.animation = animation
        self.completion = nil
        
        // Debug: Print animation loading status
        if let animation = animation {
            print("✅ CustomLottieView: Animation loaded successfully")
            print("📊 Animation duration: \(animation.duration) seconds")
            print("🎬 Animation frame rate: \(animation.framerate) fps")
            print("📏 Total frames: \(animation.endFrame - animation.startFrame)")
            print("🎯 Start frame: \(animation.startFrame), End frame: \(animation.endFrame)")
        } else {
            print("❌ CustomLottieView: Failed to load animation")
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        // Create a container view that will properly handle sizing
        let containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        
        let animationView = LottieAnimationView()
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce  // Default to play once, will be overridden in updateUIView
        animationView.animationSpeed = animationSpeed  // Set the playback speed
        animationView.backgroundColor = UIColor.clear
        
        // Store completion callback for later use in updateUIView
        // We'll set up the completion when we actually play the animation
        
        // Disable autoresizing masks to use Auto Layout
        animationView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(animationView)
        
        // Fill the entire container
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        // Store the animation view for updates
        containerView.tag = 999 // Use tag to find it later
        
        // Debug: Check if animation was set
        if animationView.animation != nil {
            print("✅ LottieAnimationView: Animation assigned to view")
            if let animation = animationView.animation {
                print("📐 Animation intrinsic size: \(animation.size)")
            }
        } else {
            print("❌ LottieAnimationView: No animation assigned to view")
        }
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Find the animation view within the container
        guard let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView else {
            print("❌ Could not find LottieAnimationView in container")
            return
        }
        
        // Check if animation is already playing to avoid restarting
        let isCurrentlyPlaying = animationView.isAnimationPlaying
        
        // If animation is nil (completed state), don't try to play anything
        guard animation != nil else {
            print("🚫 No animation available, skipping playback")
            animationView.stop()
            return
        }
        
        // Update animation speed in case it changed
        animationView.animationSpeed = animationSpeed
        
        // Apply playback mode
        switch playbackMode {
        case .playing(let mode):
            switch mode {
            case .fromProgress(let fromProgress, let toProgress, let loopMode):
                animationView.loopMode = loopMode
                
                // Only start if not already playing the same segment
                if !isCurrentlyPlaying {
                    if let completion = completion {
                        animationView.play(fromProgress: fromProgress, toProgress: toProgress) { finished in
                            if finished {
                                DispatchQueue.main.async {
                                    completion()
                                }
                            }
                        }
                    } else {
                        animationView.play(fromProgress: fromProgress, toProgress: toProgress)
                    }
                    print("🎮 Playing from progress \(fromProgress) to \(toProgress)")
                } else {
                    print("⏭️ Animation already playing, skipping restart")
                }
                
            case .fromFrame(let fromFrame, let toFrame, let loopMode):
                animationView.loopMode = loopMode
                
                // Only start if not already playing the same segment
                if !isCurrentlyPlaying {
                    if let completion = completion {
                        animationView.play(fromFrame: AnimationFrameTime(fromFrame), toFrame: AnimationFrameTime(toFrame)) { finished in
                            if finished {
                                print("✅ Animation segment completed: frames \(fromFrame)-\(toFrame)")
                                DispatchQueue.main.async {
                                    completion()
                                }
                            }
                        }
                    } else {
                        animationView.play(fromFrame: AnimationFrameTime(fromFrame), toFrame: AnimationFrameTime(toFrame))
                    }
                    print("🎮 Playing from frame \(fromFrame) to \(toFrame) with loop mode: \(loopMode)")
                } else {
                    print("⏭️ Animation already playing frames \(fromFrame)-\(toFrame), skipping restart")
                }
            }
            
        case .paused:
            animationView.pause()
            print("⏸️ Animation paused")
        }
    }
    
    func playing(_ mode: LottiePlayMode = .fromProgress(0, toProgress: 1, loopMode: .playOnce)) -> CustomLottieView {
        var view = self
        view.playbackMode = .playing(mode)
        return view
    }

    func speed(_ speed: CGFloat) -> CustomLottieView {
        var view = self
        view.animationSpeed = speed
        return view
    }

    func paused() -> CustomLottieView {
        var view = self
        view.playbackMode = .paused
        return view
    }
}

/// Convenience wrapper for common use cases
struct LottieView: View {
    let animationName: String
    let loopMode: LottieLoopMode
    let fromFrame: AnimationFrameTime?
    let toFrame: AnimationFrameTime?
    let completion: (() -> Void)?
    let playbackSpeed: CGFloat
    
    init(
        animationName: String,
        loopMode: LottieLoopMode = .playOnce,
        segment: LottieSegment? = nil,
        completion: (() -> Void)? = nil,
        playbackSpeed: CGFloat = AnimationConstants.lottiePlaybackSpeed
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.fromFrame = segment?.startFrame
        self.toFrame = segment?.endFrame
        self.completion = completion
        self.playbackSpeed = playbackSpeed
    }
    
    var body: some View {
        let animation = loadAnimation()
        
        if let fromFrame = fromFrame, let toFrame = toFrame {
            print("🎯 LottieView: Creating view for frames \(fromFrame)-\(toFrame) at \(playbackSpeed)x speed")
            return CustomLottieView(animation: animation, completion: completion)
                .playing(.fromFrame(fromFrame, toFrame: toFrame, loopMode: loopMode))
                .speed(playbackSpeed)
        } else {
            print("🎯 LottieView: Creating paused view (no segment provided) at \(playbackSpeed)x speed")
            return CustomLottieView(animation: animation, completion: completion)
                .paused()
                .speed(playbackSpeed)
        }
    }
    
    /// Try loading animation with multiple formats
    private func loadAnimation() -> LottieAnimation? {
        // Try JSON first (more compatible), then .lottie format
        if let jsonAnimation = LottieAnimation.named(animationName + ".json") {
            print("✅ Loaded animation from JSON format: \(animationName).json")
            return jsonAnimation
        } else if let lottieAnimation = LottieAnimation.named(animationName + ".lottie") {
            print("✅ Loaded animation from .lottie format: \(animationName).lottie")
            return lottieAnimation
        } else if let baseAnimation = LottieAnimation.named(animationName) {
            print("✅ Loaded animation with base name: \(animationName)")
            return baseAnimation
        } else {
            print("❌ Failed to load animation with any format: \(animationName)")
            return nil
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

// MARK: - Playback Configuration
enum LottiePlaybackMode {
    case playing(LottiePlayMode)
    case paused
}

enum LottiePlayMode {
    case fromProgress(AnimationProgressTime, toProgress: AnimationProgressTime, loopMode: LottieLoopMode)
    case fromFrame(AnimationFrameTime, toFrame: AnimationFrameTime, loopMode: LottieLoopMode)
}

// MARK: - Debug Utility
struct LottieDebugView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Lottie Debug Console")
                .font(.system(size: 24, weight: .bold))
                .padding()
            
            // Test 1: Check if file exists in bundle
            Button("Test 1: Check Bundle Resources") {
                checkBundleResources()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            // Test 2: Try loading animation
            Button("Test 2: Load Animation") {
                testAnimationLoading()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            // Test 3: List all bundle files
            Button("Test 3: List All Bundle Files") {
                listAllBundleFiles()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
    
    private func checkBundleResources() {
        print("\n🔍 === BUNDLE RESOURCE CHECK ===")
        
        // Check for .lottie file
        if let lottieUrl = Bundle.main.url(forResource: "olivia-splash-login-lottie_1.1", withExtension: "lottie") {
            print("✅ Found .lottie file at: \(lottieUrl.path)")
            
            // Check file size
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: lottieUrl.path)
                if let fileSize = attributes[.size] as? Int64 {
                    print("📏 File size: \(fileSize) bytes")
                }
            } catch {
                print("⚠️ Could not get file attributes: \(error)")
            }
        } else {
            print("❌ .lottie file not found in bundle")
        }
        
        // Check for .json file (alternative format)
        if let jsonUrl = Bundle.main.url(forResource: "olivia-splash-login-lottie_1.1", withExtension: "json") {
            print("✅ Found .json file at: \(jsonUrl.path)")
        } else {
            print("❌ .json file not found in bundle")
        }
        
        print("=== END BUNDLE CHECK ===\n")
    }
    
    private func testAnimationLoading() {
        print("\n🎬 === ANIMATION LOADING TEST ===")
        
        // Test JSON format first
        if let jsonAnimation = LottieAnimation.named("olivia-splash-login-lottie_1.1.json") {
            print("✅ LottieAnimation.named() with .json succeeded")
            print("📊 Duration: \(jsonAnimation.duration) seconds")
            print("🎬 Frame rate: \(jsonAnimation.framerate) fps")
            print("🎯 Frames: \(jsonAnimation.startFrame) to \(jsonAnimation.endFrame)")
        } else {
            print("❌ LottieAnimation.named() with .json failed")
        }
        
        // Test .lottie format
        if let lottieAnimation = LottieAnimation.named("olivia-splash-login-lottie_1.1.lottie") {
            print("✅ LottieAnimation.named() with .lottie succeeded")
            print("📊 Duration: \(lottieAnimation.duration) seconds")
            print("🎬 Frame rate: \(lottieAnimation.framerate) fps")
            print("🎯 Frames: \(lottieAnimation.startFrame) to \(lottieAnimation.endFrame)")
        } else {
            print("❌ LottieAnimation.named() with .lottie failed")
        }
        
        // Test base name (no extension)
        if let animation = LottieAnimation.named("olivia-splash-login-lottie_1.1") {
            print("✅ LottieAnimation.named() base name succeeded")
            print("📊 Duration: \(animation.duration) seconds")
            print("🎬 Frame rate: \(animation.framerate) fps")
            print("🎯 Frames: \(animation.startFrame) to \(animation.endFrame)")
        } else {
            print("❌ LottieAnimation.named() base name failed")
        }
        
        // Test with filepath for JSON
        if let bundlePath = Bundle.main.path(forResource: "olivia-splash-login-lottie_1.1", ofType: "json"),
           let animation = LottieAnimation.filepath(bundlePath) {
            print("✅ LottieAnimation.filepath() with JSON succeeded")
            print("📊 Duration: \(animation.duration) seconds")
        } else {
            print("❌ LottieAnimation.filepath() with JSON failed")
        }
        
        // Test with filepath for .lottie
        if let bundlePath = Bundle.main.path(forResource: "olivia-splash-login-lottie_1.1", ofType: "lottie"),
           let animation = LottieAnimation.filepath(bundlePath) {
            print("✅ LottieAnimation.filepath() with .lottie succeeded")
            print("📊 Duration: \(animation.duration) seconds")
        } else {
            print("❌ LottieAnimation.filepath() with .lottie failed")
        }
        
        print("=== END LOADING TEST ===\n")
    }
    
    private func listAllBundleFiles() {
        print("\n📁 === ALL BUNDLE FILES ===")
        
        if let bundlePath = Bundle.main.resourcePath {
            let fileManager = FileManager.default
            
            func listFiles(in directory: String, prefix: String = "") {
                do {
                    let items = try fileManager.contentsOfDirectory(atPath: directory)
                    for item in items.sorted() {
                        let itemPath = "\(directory)/\(item)"
                        var isDirectory: ObjCBool = false
                        
                        if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory) {
                            if isDirectory.boolValue {
                                print("\(prefix)📁 \(item)/")
                                if item.lowercased().contains("lottie") || item.lowercased().contains("resources") {
                                    listFiles(in: itemPath, prefix: prefix + "  ")
                                }
                            } else {
                                if item.lowercased().contains("lottie") || item.hasSuffix(".json") {
                                    print("\(prefix)📄 \(item) ⭐")
                                } else {
                                    print("\(prefix)📄 \(item)")
                                }
                            }
                        }
                    }
                } catch {
                    print("\(prefix)❌ Error reading directory: \(error)")
                }
            }
            
            listFiles(in: bundlePath)
        }
        
        print("=== END FILE LIST ===\n")
    }
}

// MARK: - Debug Previews (iOS 13 Compatible)
#Preview("Lottie Debug Console") {
    LottieDebugView()
}

#Preview("Basic Lottie Test") {
    VStack {
        Text("Testing Basic Lottie Animation")
            .font(.system(size: 20, weight: .semibold))
            .padding()
        
        // Test basic animation loading
        CustomLottieView(animation: .named("olivia-splash-login-lottie_1.1"))
            .playing()
            .frame(width: 300, height: 300)
            .border(Color.red, width: 2) // Visual border to see the frame
        
        Text("If you see a red border but no animation,\nthe Lottie file might not be loading.")
            .multilineTextAlignment(.center)
            .padding()
    }
}

#Preview("Splash Segment Test") {
    VStack {
        Text("Testing Splash Segment (0-207)")
            .font(.system(size: 20, weight: .semibold))
            .padding()
        
        // Test splash segment specifically
        CustomLottieView(animation: .named("olivia-splash-login-lottie_1.1"))
            .playing(.fromFrame(0, toFrame: 207, loopMode: .playOnce))
            .frame(width: 300, height: 300)
            .border(Color.blue, width: 2)
        
        Text("Splash Segment: Frames 0-207")
            .padding()
    }
}

#Preview("Login Segment Test") {
    VStack {
        Text("Testing Login Segment (208-285)")
            .font(.system(size: 20, weight: .semibold))
            .padding()
        
        // Test login segment specifically
        CustomLottieView(animation: .named("olivia-splash-login-lottie_1.1"))
            .playing(.fromFrame(208, toFrame: 285, loopMode: .playOnce))
            .frame(width: 300, height: 300)
            .border(Color.green, width: 2)
        
        Text("Login Segment: Frames 208-285")
            .padding()
    }
} 
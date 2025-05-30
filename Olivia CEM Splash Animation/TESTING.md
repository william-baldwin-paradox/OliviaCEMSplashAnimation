# Testing the Splash Animation Component

This document explains how to set up and run tests for the Olivia CEM Splash Animation component.

## Setting Up a Test Target

When integrating this component into your application, you may want to add tests to ensure it works correctly with your codebase. To do this properly:

1. In Xcode, select your project in the Project Navigator
2. Click on the "+" button at the bottom of the targets list
3. Choose "Unit Test Bundle" as the template
4. Name your test target (e.g., "OliviaSplashTests")
5. Click "Finish"

## Example Test Implementation

Once you have a test target, you can create test cases like the following:

```swift
import XCTest
import SwiftUI
import RiveRuntime
@testable import YourAppTargetName // Replace with your actual app target name

class SplashViewModelTests: XCTestCase {
    
    // Test initial state
    func testSplashViewModelInitialization() {
        let viewModel = SplashViewModel()
        
        // Verify initial state
        XCTAssertFalse(viewModel.showLoginUI)
        XCTAssertEqual(viewModel.animationProgress, 0)
        XCTAssertEqual(viewModel.loginViewOpacity, 0)
        XCTAssertEqual(viewModel.loginViewOffset, 200)
        XCTAssertNil(viewModel.riveViewModel)
    }
    
    // Test progress updates
    func testUpdateInitializationProgress() {
        let viewModel = SplashViewModel()
        
        // Create a mock RiveViewModel
        let mockViewModel = MockRiveViewModel()
        viewModel.setMockRiveViewModel(mockViewModel)
        
        // Call the method under test
        viewModel.updateInitializationProgress(75.0)
        
        // Verify results
        XCTAssertEqual(mockViewModel.lastInput, "initializationPercent")
        XCTAssertEqual(mockViewModel.lastValue, 75.0)
    }
    
    // Test fallback timer
    func testFallbackTimer() {
        // Create a test expectation
        let expectation = XCTestExpectation(description: "Fallback timer triggers login UI")
        
        // Use a faster configuration for testing
        let testConfig = SplashConfig(
            riveFileName: "test-animation",
            stateMachineName: "TestStateMachine",
            artboardName: "TEST",
            tabletArtboardName: "TEST-tab",
            initializationInputName: "initializationPercent",
            logoTransitionEventName: "logoDelta",
            minimumLoadTime: 0.1, // Short for tests
            fallbackTimeout: 0.2  // Short for tests
        )
        
        // Create the view model with test configuration
        let viewModel = SplashViewModel(config: testConfig)
        
        // Setup completion handler
        viewModel.setOnSplashComplete {
            expectation.fulfill()
        }
        
        // Start the animation (triggers the timer)
        viewModel.setupRiveAnimation()
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
        
        // Verify login UI is shown
        XCTAssertTrue(viewModel.showLoginUI)
    }
}

// Mock for testing
class MockRiveViewModel {
    var lastInput: String = ""
    var lastValue: Double = 0.0
    
    func setInput(_ inputName: String, value: Double) {
        lastInput = inputName
        lastValue = value
    }
}
```

## What to Test

For the splash animation component, consider testing:

1. **Initialization**: Verify default values are set correctly
2. **Progress Updates**: Test that updating progress works correctly
3. **Fallback Timer**: Confirm the fallback timer shows the login UI if no event arrives
4. **Event Handling**: Verify the component responds correctly to Rive events
5. **UI State**: Test that UI properties (opacity, offset) change as expected

## UI Testing

You can also create UI tests to verify the visual appearance and behavior:

1. Add a UI Test target in Xcode similar to the Unit Test target
2. Create tests that launch your app and verify the splash screen appears and transitions correctly

```swift
import XCTest

class SplashUITests: XCTestCase {
    func testSplashToLoginTransition() {
        let app = XCUIApplication()
        app.launch()
        
        // Verify splash screen appears
        XCTAssertTrue(app.otherElements["splashView"].exists)
        
        // Wait for transition to login
        let loginButton = app.buttons["signInButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10))
        
        // Verify login UI is visible
        XCTAssertTrue(loginButton.isHittable)
    }
}
``` 
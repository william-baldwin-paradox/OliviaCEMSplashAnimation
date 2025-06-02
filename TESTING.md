# Testing Guidelines for Olivia CEM Splash Animation

This component is intended to be integrated into a variety of projects, some of which may use older Swift or Xcode versions. Instead of prescribing exact test code (which might not compile everywhere), use the checklist below to ensure the splash behaves correctly in **your** setup.

## What to Verify

1. **Event → State**  
   • When the Rive event `logoDelta` fires, `SplashViewModel.showLoginUI` should change to `true`.

2. **UI Transition**  
   • After `showLoginUI` becomes `true`, the embedded `LoginView` should appear from the bottom and become fully visible.

3. **Fallback Behaviour**  
   • If the event never arrives (e.g. animation fails), `SplashViewModel` should still toggle `showLoginUI` after the fallback timeout defined in `AnimationConstants.minimumLoadTime`.

4. **Accessibility**  
   • VoiceOver should not focus the Rive animation.  
   • All interactive elements in `LoginView` must be reachable and announced.

## Suggested Approaches

• **Unit Tests**:  Inject a mock `RiveView` or publish a `showLoginUI` change manually and assert the expected state transitions.  
• **UI Tests**:  Launch the app, wait for a known element in `LoginView` (e.g. the sign-in button) to become hittable, and assert it exists within an acceptable time window.

Adapt the exact assertions and identifiers to match your project's naming conventions. By focusing on the observable behaviour rather than internal implementation details, these tests will remain valid even if you refactor the component later. 

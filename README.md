# IOS Version_of_Multiple_Doctor_App

Native iOS rebuild of the current Expo prototype.

## Scope

- SwiftUI app with local-only storage and no React Native runtime
- Mirrors the existing project architecture:
  - app shell and route stack
  - feature modules
  - shared models and seed data
  - local storage and deterministic plan generation
- Builds for iOS devices and simulators through Xcode tooling

## Generate The Project

```bash
cd "IOS Version_of_Multiple_Doctor_App"
xcodegen generate
```

## Build On Simulator

```bash
xcodebuild \
  -project IOSVersionOfMultipleDoctorApp.xcodeproj \
  -scheme IOSVersionOfMultipleDoctorApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

## Current Assumption

This native rewrite preserves the current product behavior from the React Native app. If the new app should change from fitness coaching into a doctor-specific workflow, the domain model and flows should be adjusted next.

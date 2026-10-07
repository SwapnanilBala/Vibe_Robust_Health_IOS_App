# Robust Health — iOS

A native SwiftUI rebuild of the [Robust Health](https://app.robusthealth.in) fitness app's Expo
prototype, with no React Native runtime. Everything runs on-device: profiles, members and plans are
stored locally, and plans come from a deterministic planner engine.

> The Xcode target is still called `IOSVersionOfMultipleDoctorApp`, a leftover from the project's
> first name. The app itself is Robust Health.

## Flows

| Screen | What it does |
|---|---|
| Home | Entry point to onboarding, plans, member and trainer portals, and pricing |
| Onboarding | Validates and saves a profile, then generates the first plan |
| Plan | Shows the latest plan; regenerate it for the active profile |
| Member | Email login, saved plans, filter by coach |
| Trainer | Credential login, assigned clients, profile snapshots |
| Pricing | Pick a plan tier and return to the plan |

## Architecture

- One SwiftUI target with `NavigationStack`, iOS 17+, Swift 6.
- **Feature services** (`Features/*/*Service.swift`) keep business logic out of the views.
- `PlannerEngine` generates plans deterministically and locally, so it can be swapped for a backend later.
- `LocalDatabase` persists JSON-encoded models in `UserDefaults`.
- Models mirror the TypeScript contracts of the original app. [`ARCHITECTURE.md`](ARCHITECTURE.md) maps every React Native module to its Swift counterpart.

```text
App/        entry point, root view, app state, dependency container
Features/   Home, Onboarding, Plans (+ PlannerEngine), Member, Trainer, Pricing
Shared/     components, models, seed data, local storage, theme
Resources/  asset catalog
project.yml XcodeGen spec
```

## Build it

Needs Xcode with an iOS 17+ SDK. Regenerating the project needs [XcodeGen](https://github.com/yonaskolb/XcodeGen) 2.38+.

```bash
xcodegen generate        # from the repo root: rebuilds the .xcodeproj from project.yml
xcodebuild \
  -project IOSVersionOfMultipleDoctorApp.xcodeproj \
  -scheme IOSVersionOfMultipleDoctorApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

Or open `IOSVersionOfMultipleDoctorApp.xcodeproj` in Xcode and run it on a simulator.

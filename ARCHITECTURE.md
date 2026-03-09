# Native iOS Architecture

## Mapping From The Existing App

- `App.tsx` and `src/navigation/`
  - `App/IOSVersionOfMultipleDoctorAppApp.swift`
  - `App/RootView.swift`
  - `App/AppState.swift`
- `src/screens/`
  - `Features/*/*View.swift`
- `src/features/`
  - `Features/*/*Service.swift`
  - `Features/Plans/PlannerEngine.swift`
- `src/features/shared/`
  - `Shared/Models/`
  - `Shared/Data/AppSeedData.swift`
  - `Shared/Storage/LocalDatabase.swift`
- `src/components/` and `src/theme/`
  - `Shared/Components/`
  - `Shared/Theme/AppTheme.swift`

## Design Principles

- Single native target using SwiftUI and `NavigationStack`
- Local persistence with `UserDefaults` and JSON encoding
- Feature services isolate business logic from views
- Shared models remain close to the current TypeScript contracts
- Deterministic plan generation stays local and swappable later

## Feature Flows

- Home
  - jump to onboarding, plan, member, trainer, pricing
- Onboarding
  - validate profile, save local profile, generate initial plan
- Plan
  - show latest plan and regenerate for active profile
- Member
  - email login, saved plans, coach filtering
- Trainer
  - credential login, assigned client list, profile snapshot access
- Pricing
  - local plan tier selection and transition back to plan

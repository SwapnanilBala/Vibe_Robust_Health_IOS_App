import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack(path: $appState.path) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .onboarding:
                        OnboardingView()
                    case .plan:
                        PlanView()
                    case .memberLogin:
                        MemberLoginView()
                    case .memberDashboard:
                        MemberDashboardView()
                    case .trainerLogin:
                        TrainerLoginView()
                    case .trainerClients:
                        TrainerClientsView()
                    case .pricing:
                        PricingView()
                    }
                }
        }
        .tint(AppTheme.Colors.accent)
    }
}

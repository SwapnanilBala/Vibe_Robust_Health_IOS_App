import SwiftUI

private enum BillingPeriod: String, CaseIterable, Identifiable {
    case monthly
    case yearly

    var id: String { rawValue }
    var label: String { self == .monthly ? "Monthly billing" : "Yearly billing" }
}

private enum PricingTier: String, CaseIterable, Identifiable {
    case starter
    case pro
    case elite

    var id: String { rawValue }

    var name: String {
        rawValue.capitalized
    }

    var accent: Color {
        switch self {
        case .starter:
            return Color(red: 0.15, green: 0.39, blue: 0.92)
        case .pro:
            return Color(red: 0.92, green: 0.35, blue: 0.05)
        case .elite:
            return Color(red: 0.06, green: 0.46, blue: 0.43)
        }
    }

    var monthlyUsd: Int {
        switch self {
        case .starter: return 29
        case .pro: return 59
        case .elite: return 99
        }
    }

    var yearlyUsd: Int {
        switch self {
        case .starter: return 290
        case .pro: return 590
        case .elite: return 990
        }
    }

    var pitch: String {
        switch self {
        case .starter:
            return "Best for staying consistent with your routine."
        case .pro:
            return "Balanced coaching support and stronger accountability."
        case .elite:
            return "Highest-touch support for accelerated outcomes."
        }
    }

    var bullets: [String] {
        switch self {
        case .starter:
            return ["Weekly plan updates", "Nutrition macro targets", "Basic progress check-ins"]
        case .pro:
            return ["Everything in Starter", "Workout form tips", "Priority plan adjustments"]
        case .elite:
            return ["Everything in Pro", "Recovery and stress optimization", "Personalized coaching guidance"]
        }
    }
}

struct PricingView: View {
    @EnvironmentObject private var appState: AppState

    @State private var billing: BillingPeriod = .monthly
    @State private var selectedTier: PricingTier = .pro
    @State private var showingSelectionAlert = false

    var body: some View {
        BackdropView(variant: .pricing) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Next Step")
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(AppTheme.Colors.warning)
                        .textCase(.uppercase)

                    Text("Choose your coaching plan")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text("Your first training plan is ready. Pick a tier to continue your journey.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(BillingPeriod.allCases) { period in
                            let active = billing == period
                            Button {
                                billing = period
                            } label: {
                                Text(period.label)
                                    .font(AppTheme.Typography.label)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(active ? Color(red: 1.0, green: 0.89, blue: 0.78) : Color(red: 1.0, green: 0.95, blue: 0.91))
                                    .foregroundStyle(active ? Color(red: 0.49, green: 0.18, blue: 0.07) : AppTheme.Colors.warning)
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(active ? AppTheme.Colors.warning : Color(red: 0.90, green: 0.70, blue: 0.56), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    ForEach(PricingTier.allCases) { tier in
                        let active = tier == selectedTier
                        let price = billing == .monthly ? tier.monthlyUsd : tier.yearlyUsd
                        let suffix = billing == .monthly ? "/month" : "/year"

                        Button {
                            selectedTier = tier
                        } label: {
                            AppCard {
                                Text(tier.name)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(tier.accent)
                                Text("$\(price)")
                                    .font(.system(size: 30, weight: .heavy))
                                    .foregroundStyle(AppTheme.Colors.text)
                                + Text(suffix)
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppTheme.Colors.muted)
                                Text(tier.pitch)
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(Color(red: 0.22, green: 0.27, blue: 0.33))
                                ForEach(tier.bullets, id: \.self) { bullet in
                                    Text("• \(bullet)")
                                        .font(.system(size: 13))
                                        .foregroundStyle(AppTheme.Colors.text)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .stroke(active ? tier.accent : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(title: "Continue with \(selectedTier.name)") {
                            showingSelectionAlert = true
                        }
                        PrimaryButton(title: "Skip for now", variant: .secondary) {
                            appState.replaceCurrent(with: .plan)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Pricing")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Plan selected", isPresented: $showingSelectionAlert) {
            Button("Continue") {
                appState.replaceCurrent(with: .plan)
            }
        } message: {
            let price = billing == .monthly ? "$\(selectedTier.monthlyUsd)/month" : "$\(selectedTier.yearlyUsd)/year"
            Text("\(selectedTier.name) (\(price)) selected in this native build.")
        }
    }
}

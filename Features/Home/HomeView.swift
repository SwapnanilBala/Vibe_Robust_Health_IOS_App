import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    private let features: [(title: String, hint: String, route: AppRoute, colors: [Color])] = [
        ("Onboarding", "Collect training goals and constraints.", .onboarding, [Color(red: 0.58, green: 0.77, blue: 0.99), Color(red: 0.99, green: 0.73, blue: 0.45), Color(red: 0.53, green: 0.94, blue: 0.67)]),
        ("Current Plan", "View and regenerate your active weekly plan.", .plan, [Color(red: 0.77, green: 0.71, blue: 0.99), Color(red: 0.99, green: 0.64, blue: 0.69), Color(red: 0.40, green: 0.91, blue: 0.98)]),
        ("Member Hub", "Login to see saved plans and coach options.", .memberLogin, [Color(red: 0.98, green: 0.66, blue: 0.84), Color(red: 0.75, green: 0.86, blue: 1.0), Color(red: 0.99, green: 0.90, blue: 0.54)]),
        ("Trainer Hub", "Login and monitor assigned clients.", .trainerLogin, [Color(red: 0.60, green: 0.97, blue: 0.89), Color(red: 0.85, green: 0.71, blue: 0.98), Color(red: 0.99, green: 0.73, blue: 0.45)])
    ]

    private let columns = [GridItem(.flexible(), spacing: AppTheme.Spacing.md), GridItem(.flexible(), spacing: AppTheme.Spacing.md)]

    var body: some View {
        BackdropView(variant: .home) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Robust Health")
                            .font(AppTheme.Typography.label)
                            .foregroundStyle(AppTheme.Colors.accent)
                            .textCase(.uppercase)

                        Text("Train smarter with a plan that fits real life.")
                            .font(AppTheme.Typography.display)
                            .foregroundStyle(AppTheme.Colors.text)

                        Text("Native iOS version with onboarding, plan generation, member dashboard, and trainer portal.")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.muted)

                        RoundedRectangle(cornerRadius: 999)
                            .fill(Color(red: 0.49, green: 0.83, blue: 0.98).opacity(0.55))
                            .frame(width: 180, height: 8)
                    }

                    LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
                        ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                            Button {
                                appState.navigate(to: feature.route)
                            } label: {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                    HStack(spacing: 8) {
                                        Circle()
                                            .fill(feature.colors[0])
                                            .frame(width: 14, height: 14)
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(feature.colors[1])
                                            .frame(width: 12, height: 12)
                                            .rotationEffect(.degrees(45))
                                        Capsule()
                                            .fill(feature.colors[2])
                                            .frame(width: 28, height: 8)
                                    }

                                    Text(feature.title)
                                        .font(AppTheme.Typography.title)
                                        .foregroundStyle(AppTheme.Colors.text)

                                    Text(feature.hint)
                                        .font(.system(size: 12, weight: .regular, design: .default))
                                        .foregroundStyle(Color(red: 0.22, green: 0.27, blue: 0.33))
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(AppTheme.Spacing.md)
                                .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                                .background(Color.white.opacity(0.86))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color(red: 0.84, green: 0.86, blue: 0.91), lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    AppCard {
                        Text("Quick Start")
                            .font(AppTheme.Typography.title)
                            .foregroundStyle(AppTheme.Colors.text)

                        VStack(spacing: AppTheme.Spacing.sm) {
                            PrimaryButton(title: "Start onboarding") {
                                appState.navigate(to: .onboarding)
                            }
                            PrimaryButton(title: "Open member dashboard", variant: .secondary) {
                                appState.navigate(to: .memberLogin)
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Robust Health")
        .navigationBarTitleDisplayMode(.inline)
    }
}

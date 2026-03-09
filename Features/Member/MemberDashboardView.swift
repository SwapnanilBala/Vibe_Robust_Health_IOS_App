import SwiftUI

struct MemberDashboardView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var member: Member?
    @State private var plans: [StoredPlan] = []
    @State private var selectedSpecialties: Set<CoachSpecialty> = []

    var filteredCoaches: [CoachProfile] {
        let coaches = container.memberService.coachDirectory()
        if selectedSpecialties.isEmpty {
            return coaches
        }
        return coaches.filter { coach in
            !Set(coach.specialties).isDisjoint(with: selectedSpecialties)
        }
    }

    var body: some View {
        BackdropView(variant: .member) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Member Dashboard")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text(member.map { "Logged in as \($0.email)" } ?? "No member session found.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(title: "Create or refresh plan") {
                            appState.navigate(to: .onboarding)
                        }
                        PrimaryButton(title: "Back to home", variant: .secondary) {
                            appState.resetToRoot()
                        }
                    }

                    AppCard {
                        Text("Saved plans")
                            .font(AppTheme.Typography.title)
                            .foregroundStyle(AppTheme.Colors.text)

                        if plans.isEmpty {
                            Text("No saved plans yet for this member.")
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.text)
                            PrimaryButton(title: "Create first plan") {
                                appState.navigate(to: .onboarding)
                            }
                        } else {
                            ForEach(plans) { plan in
                                VStack(alignment: .leading, spacing: 4) {
                                    Divider()
                                    Text("Week start: \(plan.weekStart)")
                                        .font(AppTheme.Typography.title)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text("Created: \(plan.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text("Split: \(plan.plan.workout.splitName)")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text("Calories: \(plan.plan.nutrition.caloriesTarget) kcal")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                }
                            }
                        }
                    }

                    AppCard {
                        Text("Find a fitness coach")
                            .font(AppTheme.Typography.title)
                            .foregroundStyle(AppTheme.Colors.text)
                        Text("Tap one or more specialties to filter.")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.text)

                        MultiSelectionChips(
                            options: AppSeedData.coachSpecialties.map { ChipOption(value: $0, label: $0.rawValue) },
                            selection: $selectedSpecialties
                        )

                        VStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(filteredCoaches) { coach in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(coach.name)
                                        .font(AppTheme.Typography.title)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text(coach.email)
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text(coach.specialties.map(\.rawValue).joined(separator: " • "))
                                        .font(.system(size: 12))
                                        .foregroundStyle(AppTheme.Colors.muted)
                                    Text("$\(coach.monthlyFeeUsd)/month • $\(coach.yearlyFeeUsd)/year")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                }
                                .padding(AppTheme.Spacing.sm)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Member Plans")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            load()
        }
    }

    private func load() {
        member = container.memberService.activeMember()
        if let member {
            plans = container.memberService.plansForMember(memberId: member.id)
        } else {
            plans = []
        }
    }
}

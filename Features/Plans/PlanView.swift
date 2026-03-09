import SwiftUI

struct PlanView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var plan: StoredPlan?
    @State private var isLoading = true
    @State private var alertMessage: String?

    var body: some View {
        BackdropView(variant: .plan) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Your Training Plan")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text("Structured weekly programming with local deterministic generation.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(title: "Regenerate plan", disabled: isLoading) {
                            regenerate()
                        }
                        PrimaryButton(title: "Re-configure profile", variant: .secondary) {
                            appState.navigate(to: .onboarding)
                        }
                        PrimaryButton(title: "Open pricing", variant: .secondary) {
                            appState.navigate(to: .pricing)
                        }
                    }

                    content
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Your Plan")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadPlan()
        }
        .alert("Plan Error", isPresented: alertBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage ?? "Unknown error")
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            AppCard {
                Text("Loading plan...")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.text)
            }
        } else if let plan {
            AppCard {
                sectionTitle("Nutrition")
                Text("Calories target: \(plan.plan.nutrition.caloriesTarget) kcal")
                Text("Protein: \(plan.plan.nutrition.proteinG) g")
                Text("Carbs: \(plan.plan.nutrition.carbsG) g")
                Text("Fat: \(plan.plan.nutrition.fatG) g")
                Text("Water: \(String(format: "%.1f", plan.plan.nutrition.waterLiters)) L")
            }

            AppCard {
                sectionTitle("Sleep & Recovery")
                Text("Target sleep: \(plan.plan.sleep.targetHours) hours")
                Text("Bedtime hint: \(plan.plan.sleep.bedtimeHint)")
                Text("Recovery score: \(plan.plan.sleep.recoveryScore)")
                ForEach(plan.plan.sleep.nudges, id: \.self) { nudge in
                    bullet(nudge)
                }
            }

            AppCard {
                sectionTitle("Workout Split")
                Text("Split: \(plan.plan.workout.splitName)")
                Text("Phase: \(plan.plan.workout.phase.rawValue.capitalized)")
                Text("Week \(plan.plan.workout.weekInMesocycle) of \(plan.plan.workout.mesocycleLength)")

                ForEach(plan.plan.workout.days) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                        Text(day.name)
                            .font(AppTheme.Typography.title)
                            .foregroundStyle(AppTheme.Colors.text)
                        Text("\(day.focus) • \(day.estimatedMinutes) min")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.text)
                        ForEach(day.exercises.prefix(4)) { exercise in
                            bullet("\(exercise.name): \(exercise.sets) x \(exercise.reps)")
                        }
                    }
                }
            }
        } else {
            AppCard {
                Text("No plan found")
                    .font(AppTheme.Typography.title)
                    .foregroundStyle(AppTheme.Colors.text)
                Text("Complete onboarding to generate your first plan.")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(AppTheme.Colors.text)
                PrimaryButton(title: "Go to onboarding") {
                    appState.navigate(to: .onboarding)
                }
            }
        }
    }

    private var alertBinding: Binding<Bool> {
        Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )
    }

    private func loadPlan() {
        isLoading = true
        plan = container.planService.latestPlanForActiveProfile()
        isLoading = false
    }

    private func regenerate() {
        isLoading = true
        defer { isLoading = false }

        do {
            plan = try container.planService.regeneratePlanForActiveProfile()
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(AppTheme.Typography.title)
            .foregroundStyle(AppTheme.Colors.text)
    }

    private func bullet(_ text: String) -> some View {
        Text("• \(text)")
            .font(AppTheme.Typography.body)
            .foregroundStyle(AppTheme.Colors.text)
    }
}

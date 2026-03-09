import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var form = Profile.default
    @State private var isSaving = false
    @State private var alertMessage: String?

    var body: some View {
        BackdropView(variant: .onboarding) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Build your personalized week-one plan")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text("Fill out the profile once and the app will generate your first program.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    AppCard {
                        stepperRow("Age", value: $form.age, range: 14...90)
                        stepperRow("Height (cm)", value: $form.heightCm, range: 120...220)
                        stepperRow("Weight (kg)", value: $form.weightKg, range: 35...250)

                        sectionLabel("Sex at birth")
                        SelectionChips(
                            options: SexAtBirth.allCases.map { ChipOption(value: $0, label: $0.label) },
                            selection: $form.sexAtBirth
                        )
                    }

                    AppCard {
                        sectionLabel("Goal")
                        SelectionChips(
                            options: Goal.allCases.map { ChipOption(value: $0, label: $0.label) },
                            selection: $form.goal
                        )

                        sectionLabel("Activity level")
                        SelectionChips(
                            options: ActivityLevel.allCases.map { ChipOption(value: $0, label: $0.label) },
                            selection: $form.activityLevel
                        )

                        sectionLabel("Equipment")
                        SelectionChips(
                            options: Equipment.allCases.map { ChipOption(value: $0, label: $0.label) },
                            selection: $form.equipment
                        )
                    }

                    AppCard {
                        stepperRow("Days per week", value: $form.daysPerWeek, range: 1...7)
                        stepperRow("Session length (minutes)", value: $form.sessionMinutes, range: 20...180, step: 5)
                        stepperRow("Sleep hours", value: $form.sleepHours, range: 4...12)
                        stepperRow("Stress level", value: $form.stressLevel, range: 1...5)

                        labeledField(title: "Diet preference", text: $form.dietPreference)
                        labeledField(title: "Allergies", text: $form.allergies)
                        labeledEditor(title: "Limitations / injuries", text: $form.limitations)
                    }

                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(title: isSaving ? "Saving profile..." : "Save and generate plan", disabled: isSaving) {
                            save()
                        }
                        PrimaryButton(title: "Back to home", variant: .secondary, disabled: isSaving) {
                            appState.resetToRoot()
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Onboarding")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Unable to save", isPresented: alertBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage ?? "Unknown error")
        }
    }

    private var alertBinding: Binding<Bool> {
        Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )
    }

    private func save() {
        isSaving = true
        defer { isSaving = false }

        do {
            let result = try container.onboardingService.saveProfileAndGeneratePlan(input: form)
            appState.replaceCurrent(with: result.isFirstPlan ? .pricing : .plan)
        } catch {
            alertMessage = error.localizedDescription
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(AppTheme.Typography.label)
            .foregroundStyle(AppTheme.Colors.muted)
    }

    private func stepperRow(_ title: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int = 1) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(AppTheme.Typography.label)
                    .foregroundStyle(AppTheme.Colors.muted)
                Spacer()
                Text("\(value.wrappedValue)")
                    .font(AppTheme.Typography.title)
                    .foregroundStyle(AppTheme.Colors.text)
            }

            Stepper(value: value, in: range, step: step) {
                EmptyView()
            }
            .labelsHidden()
        }
    }

    private func labeledField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Typography.label)
                .foregroundStyle(AppTheme.Colors.muted)
            TextField(title, text: text)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private func labeledEditor(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Typography.label)
                .foregroundStyle(AppTheme.Colors.muted)
            TextEditor(text: text)
                .frame(minHeight: 90)
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

import SwiftUI

struct TrainerLoginView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var email = ""
    @State private var credential = ""
    @State private var isLoading = false
    @State private var alertMessage: String?

    var body: some View {
        BackdropView(variant: .trainer) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Trainer Access")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text("Local credential for this build: ")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)
                    + Text("rh-trainer-2026")
                        .font(AppTheme.Typography.mono)
                        .foregroundStyle(AppTheme.Colors.text)

                    AppCard {
                        labeledField("Trainer email", text: $email, secure: false)
                        labeledField("Special credential", text: $credential, secure: true)

                        VStack(spacing: AppTheme.Spacing.sm) {
                            PrimaryButton(title: isLoading ? "Verifying..." : "Login as trainer", disabled: isLoading) {
                                submit()
                            }
                            PrimaryButton(title: "Back to home", variant: .secondary) {
                                appState.resetToRoot()
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
        .navigationTitle("Trainer Login")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Trainer login failed", isPresented: alertBinding) {
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

    @ViewBuilder
    private func labeledField(_ title: String, text: Binding<String>, secure: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Typography.label)
                .foregroundStyle(AppTheme.Colors.muted)
            if secure {
                SecureField(title, text: text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppTheme.Colors.border, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                TextField(title, text: text)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
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
    }

    private func submit() {
        isLoading = true
        defer { isLoading = false }

        do {
            _ = try container.trainerService.loginTrainer(email: email, credential: credential)
            appState.replaceCurrent(with: .trainerClients)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}

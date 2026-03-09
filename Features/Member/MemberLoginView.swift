import SwiftUI

struct MemberLoginView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var email = ""
    @State private var isLoading = false
    @State private var alertMessage: String?

    var body: some View {
        BackdropView(variant: .member) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Member Access")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text("Use email-only login in this local native build.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    AppCard {
                        Text("Email")
                            .font(AppTheme.Typography.label)
                            .foregroundStyle(AppTheme.Colors.muted)

                        TextField("you@example.com", text: $email)
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

                        VStack(spacing: AppTheme.Spacing.sm) {
                            PrimaryButton(title: isLoading ? "Checking account..." : "Login as member", disabled: isLoading) {
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
        .navigationTitle("Member Login")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Member login failed", isPresented: alertBinding) {
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

    private func submit() {
        isLoading = true
        defer { isLoading = false }

        do {
            _ = try container.memberService.loginMember(email: email)
            appState.replaceCurrent(with: .memberDashboard)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}

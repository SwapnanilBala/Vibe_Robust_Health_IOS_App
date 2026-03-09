import SwiftUI

struct TrainerClientsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var container: AppContainer

    @State private var trainer: Trainer?
    @State private var clients: [TrainerClient] = []

    var body: some View {
        BackdropView(variant: .trainer) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Trainer Portal")
                        .font(AppTheme.Typography.display)
                        .foregroundStyle(AppTheme.Colors.text)

                    Text(trainer.map { "\($0.name)'s assigned client queue" } ?? "No trainer session found.")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.muted)

                    VStack(spacing: AppTheme.Spacing.sm) {
                        PrimaryButton(title: "Back to trainer login") {
                            appState.navigate(to: .trainerLogin)
                        }
                        PrimaryButton(title: "Home", variant: .secondary) {
                            appState.resetToRoot()
                        }
                    }

                    if clients.isEmpty {
                        AppCard {
                            Text("No assigned clients yet.")
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.text)
                        }
                    } else {
                        ForEach(clients) { client in
                            AppCard {
                                Text(client.fullName)
                                    .font(AppTheme.Typography.title)
                                    .foregroundStyle(AppTheme.Colors.text)
                                Text(client.email)
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(AppTheme.Colors.text)
                                Text("Phone: \(client.phone)")
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(AppTheme.Colors.text)
                                Text("Goal: \(client.goal.label)")
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(AppTheme.Colors.text)
                                Text("Days/week: \(client.daysPerWeek)")
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(AppTheme.Colors.text)
                                Text("Equipment: \(client.equipment.label)")
                                    .font(AppTheme.Typography.body)
                                    .foregroundStyle(AppTheme.Colors.text)

                                Divider()

                                Text("Latest local profile snapshot")
                                    .font(AppTheme.Typography.label)
                                    .foregroundStyle(AppTheme.Colors.text)

                                if let snapshot = client.profileSnapshot {
                                    Text("Goal: \(snapshot.goal.label)")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text("Days/week: \(snapshot.daysPerWeek)")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                    Text("Equipment: \(snapshot.equipment.label)")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                } else {
                                    Text("No local profile generated yet.")
                                        .font(AppTheme.Typography.body)
                                        .foregroundStyle(AppTheme.Colors.text)
                                }
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
        .navigationTitle("Trainer Clients")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            load()
        }
    }

    private func load() {
        trainer = container.trainerService.activeTrainer()
        if let trainer {
            clients = container.trainerService.trainerClients(trainerEmail: trainer.email)
        } else {
            clients = []
        }
    }
}

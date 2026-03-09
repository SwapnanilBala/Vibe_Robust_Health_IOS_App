import Foundation

final class TrainerService {
    private let database: LocalDatabase

    init(database: LocalDatabase) {
        self.database = database
    }

    func loginTrainer(email: String, credential: String) throws -> Trainer {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let trainer = AppSeedData.trainerDirectory.first(where: { $0.email == normalizedEmail }) else {
            throw AppError.validation("Trainer account not found.")
        }
        guard trainer.credential == credential.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw AppError.validation("Invalid special credential.")
        }

        database.setActiveTrainerId(trainer.id)
        return trainer
    }

    func activeTrainer() -> Trainer? {
        guard let activeTrainerId = database.getActiveTrainerId() else {
            return nil
        }
        return AppSeedData.trainerDirectory.first(where: { $0.id == activeTrainerId })
    }

    func trainerClients(trainerEmail: String) -> [TrainerClient] {
        let members = database.getMembers()
        let profiles = Dictionary(uniqueKeysWithValues: database.getProfiles().map { ($0.id, $0) })

        return AppSeedData.clientDirectory
            .filter { $0.assignedTrainerEmail == trainerEmail }
            .map { client in
                let member = members.first { $0.email.lowercased() == client.email.lowercased() }
                let snapshot = member.flatMap { $0.profileId }.flatMap { profiles[$0] }.map {
                    TrainerClient.ProfileSnapshot(goal: $0.data.goal, daysPerWeek: $0.data.daysPerWeek, equipment: $0.data.equipment)
                }

                return TrainerClient(
                    fullName: client.fullName,
                    email: client.email,
                    phone: client.phone,
                    goal: client.goal,
                    daysPerWeek: client.daysPerWeek,
                    sessionMinutes: client.sessionMinutes,
                    equipment: client.equipment,
                    assignedTrainerEmail: client.assignedTrainerEmail,
                    profileSnapshot: snapshot
                )
            }
    }
}

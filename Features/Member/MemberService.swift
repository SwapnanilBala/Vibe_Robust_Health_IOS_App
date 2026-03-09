import Foundation

final class MemberService {
    private let database: LocalDatabase

    init(database: LocalDatabase) {
        self.database = database
    }

    func loginMember(email: String) throws -> Member {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard normalizedEmail.contains("@") else {
            throw AppError.validation("Enter a valid email address.")
        }

        var members = database.getMembers()
        if let existing = members.first(where: { $0.email == normalizedEmail }) {
            database.setActiveMemberId(existing.id)
            return existing
        }

        let newMember = Member(
            id: database.makeId(prefix: "member"),
            email: normalizedEmail,
            phone: nil,
            profileId: nil
        )

        members.append(newMember)
        database.saveMembers(members)
        database.setActiveMemberId(newMember.id)
        return newMember
    }

    func activeMember() -> Member? {
        guard let activeMemberId = database.getActiveMemberId() else {
            return nil
        }
        return database.getMembers().first(where: { $0.id == activeMemberId })
    }

    func plansForMember(memberId: String) -> [StoredPlan] {
        let members = database.getMembers()
        guard let member = members.first(where: { $0.id == memberId }), let profileId = member.profileId else {
            return []
        }

        return database.getPlans()
            .filter { $0.profileId == profileId }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func coachDirectory() -> [CoachProfile] {
        AppSeedData.coachDirectory
    }
}

import Foundation

final class PlanService {
    private let database: LocalDatabase

    init(database: LocalDatabase) {
        self.database = database
    }

    func latestPlanForActiveProfile() -> StoredPlan? {
        guard let activeProfileId = database.getActiveProfileId() else {
            return nil
        }

        return database
            .getPlans()
            .filter { $0.profileId == activeProfileId }
            .sorted { $0.createdAt > $1.createdAt }
            .first
    }

    func regeneratePlanForActiveProfile() throws -> StoredPlan {
        guard let activeProfileId = database.getActiveProfileId() else {
            throw AppError.validation("No active profile found. Complete onboarding first.")
        }

        let profiles = database.getProfiles()
        guard let profile = profiles.first(where: { $0.id == activeProfileId }) else {
            throw AppError.validation("Active profile data was not found in local storage.")
        }

        let generated = PlannerEngine.buildPlan(profile: profile.data)
        let plan = StoredPlan(
            id: database.makeId(prefix: "plan"),
            profileId: activeProfileId,
            createdAt: Date(),
            weekStart: DateFormatting.fullDateISO(Calendar(identifier: .iso8601).dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()),
            plan: generated
        )

        var plans = database.getPlans()
        plans.append(plan)
        database.savePlans(plans)
        return plan
    }
}

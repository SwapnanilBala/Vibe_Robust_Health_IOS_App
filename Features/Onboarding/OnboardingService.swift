import Foundation

struct SaveProfileResult {
    let profile: StoredProfile
    let plan: StoredPlan
    let isFirstPlan: Bool
}

final class OnboardingService {
    private let database: LocalDatabase

    init(database: LocalDatabase) {
        self.database = database
    }

    func saveProfileAndGeneratePlan(input: Profile) throws -> SaveProfileResult {
        let errors = validate(profile: input)
        if !errors.isEmpty {
            throw AppError.validation(errors.joined(separator: "\n"))
        }

        let now = Date()
        let profile = StoredProfile(
            id: database.makeId(prefix: "profile"),
            createdAt: now,
            data: input
        )

        let generated = PlannerEngine.buildPlan(profile: input)
        let plan = StoredPlan(
            id: database.makeId(prefix: "plan"),
            profileId: profile.id,
            createdAt: now,
            weekStart: Self.weekStartISO(),
            plan: generated
        )

        var profiles = database.getProfiles()
        profiles.append(profile)
        database.saveProfiles(profiles)

        var plans = database.getPlans()
        let isFirstPlan = plans.isEmpty
        plans.append(plan)
        database.savePlans(plans)

        database.setActiveProfileId(profile.id)

        if let activeMemberId = database.getActiveMemberId() {
            var members = database.getMembers()
            if let index = members.firstIndex(where: { $0.id == activeMemberId }) {
                members[index].profileId = profile.id
                database.saveMembers(members)
            }
        }

        return SaveProfileResult(profile: profile, plan: plan, isFirstPlan: isFirstPlan)
    }

    func validate(profile: Profile) -> [String] {
        var errors: [String] = []

        if !(14...90).contains(profile.age) {
            errors.append("Age must be 14-90.")
        }
        if !(120...220).contains(profile.heightCm) {
            errors.append("Height must be 120-220 cm.")
        }
        if !(35...250).contains(profile.weightKg) {
            errors.append("Weight must be 35-250 kg.")
        }
        if !(1...7).contains(profile.daysPerWeek) {
            errors.append("Days per week must be 1-7.")
        }
        if !(20...180).contains(profile.sessionMinutes) {
            errors.append("Session minutes must be 20-180.")
        }
        if !(4...12).contains(profile.sleepHours) {
            errors.append("Sleep hours must be 4-12.")
        }
        if !(1...5).contains(profile.stressLevel) {
            errors.append("Stress level must be 1-5.")
        }

        return errors
    }

    private static func weekStartISO(from date: Date = Date()) -> String {
        let calendar = Calendar(identifier: .iso8601)
        let week = calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
        return DateFormatting.fullDateISO(week)
    }
}

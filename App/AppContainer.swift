import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let database: LocalDatabase
    let onboardingService: OnboardingService
    let planService: PlanService
    let memberService: MemberService
    let trainerService: TrainerService

    init() {
        let database = LocalDatabase()
        self.database = database
        self.onboardingService = OnboardingService(database: database)
        self.planService = PlanService(database: database)
        self.memberService = MemberService(database: database)
        self.trainerService = TrainerService(database: database)
    }
}

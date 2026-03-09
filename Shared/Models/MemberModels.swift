import Foundation

struct Member: Codable, Hashable, Identifiable {
    var id: String
    var email: String
    var phone: String?
    var profileId: String?
}

struct Trainer: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var email: String
    var credential: String
}

enum CoachSpecialty: String, Codable, CaseIterable, Hashable, Identifiable {
    case weightLifting = "Weight lifting Coach"
    case powerLifting = "Power lifting Coach"
    case bodyBuilding = "Body Building Coach"
    case aerobics = "Aerobics Coach"
    case crossfit = "Crosfit Coach"

    var id: String { rawValue }
}

struct CoachProfile: Codable, Hashable, Identifiable {
    var id: String { email }
    var name: String
    var email: String
    var specialties: [CoachSpecialty]
    var monthlyFeeUsd: Int
    var yearlyFeeUsd: Int
}

struct ClientDirectoryItem: Codable, Hashable, Identifiable {
    var id: String { email }
    var fullName: String
    var email: String
    var phone: String
    var goal: Goal
    var daysPerWeek: Int
    var sessionMinutes: Int
    var equipment: Equipment
    var assignedTrainerEmail: String
}

struct TrainerClient: Identifiable, Hashable {
    struct ProfileSnapshot: Hashable {
        var goal: Goal
        var daysPerWeek: Int
        var equipment: Equipment
    }

    var id: String { email }
    var fullName: String
    var email: String
    var phone: String
    var goal: Goal
    var daysPerWeek: Int
    var sessionMinutes: Int
    var equipment: Equipment
    var assignedTrainerEmail: String
    var profileSnapshot: ProfileSnapshot?
}

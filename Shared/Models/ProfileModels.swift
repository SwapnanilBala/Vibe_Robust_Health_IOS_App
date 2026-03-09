import Foundation

enum Goal: String, Codable, CaseIterable, Hashable, Identifiable {
    case fatLoss = "fat_loss"
    case muscleGain = "muscle_gain"
    case strength
    case recomp

    var id: String { rawValue }

    var label: String {
        switch self {
        case .fatLoss:
            return "Fat loss"
        case .muscleGain:
            return "Muscle gain"
        case .strength:
            return "Strength"
        case .recomp:
            return "Recomp"
        }
    }
}

enum Equipment: String, Codable, CaseIterable, Hashable, Identifiable {
    case gym
    case dumbbells
    case homeBasic = "home_basic"
    case bodyweightOnly = "bodyweight_only"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .gym:
            return "Full gym access"
        case .dumbbells:
            return "Dumbbells only"
        case .homeBasic:
            return "Home basics"
        case .bodyweightOnly:
            return "Bodyweight only"
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable, Hashable, Identifiable {
    case sedentary
    case light
    case moderate
    case high

    var id: String { rawValue }

    var label: String { rawValue.capitalized }
}

enum SexAtBirth: String, Codable, CaseIterable, Hashable, Identifiable {
    case male
    case female
    case preferNot = "prefer_not"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .preferNot:
            return "Prefer not"
        }
    }
}

struct Profile: Codable, Hashable {
    var age: Int
    var sexAtBirth: SexAtBirth
    var heightCm: Int
    var weightKg: Int
    var goal: Goal
    var daysPerWeek: Int
    var sessionMinutes: Int
    var activityLevel: ActivityLevel
    var equipment: Equipment
    var limitations: String
    var dietPreference: String
    var allergies: String
    var sleepHours: Int
    var stressLevel: Int

    static let `default` = Profile(
        age: 24,
        sexAtBirth: .preferNot,
        heightCm: 175,
        weightKg: 75,
        goal: .fatLoss,
        daysPerWeek: 4,
        sessionMinutes: 60,
        activityLevel: .moderate,
        equipment: .gym,
        limitations: "",
        dietPreference: "No preference",
        allergies: "",
        sleepHours: 7,
        stressLevel: 3
    )
}

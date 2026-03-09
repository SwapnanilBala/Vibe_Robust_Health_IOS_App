import Foundation

enum PeriodizationPhase: String, Codable {
    case accumulation
    case intensification
    case deload
}

struct NutritionPlan: Codable, Hashable {
    var bmr: Int
    var tdee: Int
    var caloriesTarget: Int
    var proteinG: Int
    var carbsG: Int
    var fatG: Int
    var fiberG: Int
    var waterLiters: Double
    var notes: [String]
    var mealTimingHints: [String]
}

struct Exercise: Codable, Hashable, Identifiable {
    var id: String { name }
    var name: String
    var sets: Int
    var reps: String
    var restSec: Int
    var intensityHint: String
    var muscleGroup: String
    var category: String
    var tempo: String?
}

struct WorkoutDay: Codable, Hashable, Identifiable {
    var id: String { name }
    var name: String
    var focus: String
    var warmup: [String]
    var exercises: [Exercise]
    var estimatedMinutes: Int
    var targetMuscles: [String]
}

struct MuscleVolumeTarget: Codable, Hashable, Identifiable {
    var id: String { muscle }
    var muscle: String
    var setsPerWeek: Int
    var frequency: Int
}

struct WorkoutPlan: Codable, Hashable {
    var splitName: String
    var days: [WorkoutDay]
    var progressionRule: String
    var safetyNotes: [String]
    var phase: PeriodizationPhase
    var weekInMesocycle: Int
    var mesocycleLength: Int
    var weeklyVolume: [MuscleVolumeTarget]
    var periodizationNotes: [String]
    var deloadStrategy: String
}

struct SleepPlan: Codable, Hashable {
    var targetHours: Int
    var bedtimeHint: String
    var nudges: [String]
    var recoveryScore: String
}

struct FullPlan: Codable, Hashable {
    var nutrition: NutritionPlan
    var workout: WorkoutPlan
    var sleep: SleepPlan
}

struct StoredProfile: Codable, Hashable, Identifiable {
    var id: String
    var createdAt: Date
    var data: Profile
}

struct StoredPlan: Codable, Hashable, Identifiable {
    var id: String
    var profileId: String
    var createdAt: Date
    var weekStart: String
    var plan: FullPlan
}

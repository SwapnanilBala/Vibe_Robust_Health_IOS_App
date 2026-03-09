import Foundation

private struct ExerciseTemplate {
    let name: String
    let focus: String
    let muscleGroup: String
    let category: String
    let equipment: Set<Equipment>
}

enum PlannerEngine {
    private static let mesocycleLength = 4

    private static let exercisePool: [ExerciseTemplate] = [
        ExerciseTemplate(name: "Barbell Back Squat", focus: "Lower Strength", muscleGroup: "quads", category: "compound", equipment: [.gym]),
        ExerciseTemplate(name: "Romanian Deadlift", focus: "Posterior Chain", muscleGroup: "hamstrings", category: "compound", equipment: [.gym, .dumbbells]),
        ExerciseTemplate(name: "Dumbbell Bench Press", focus: "Upper Push", muscleGroup: "chest", category: "compound", equipment: [.gym, .dumbbells]),
        ExerciseTemplate(name: "Push-Up", focus: "Upper Push", muscleGroup: "chest", category: "compound", equipment: [.bodyweightOnly, .homeBasic]),
        ExerciseTemplate(name: "Lat Pulldown", focus: "Upper Pull", muscleGroup: "back", category: "compound", equipment: [.gym]),
        ExerciseTemplate(name: "One-Arm Row", focus: "Upper Pull", muscleGroup: "back", category: "compound", equipment: [.dumbbells, .homeBasic]),
        ExerciseTemplate(name: "Goblet Squat", focus: "Lower Hypertrophy", muscleGroup: "quads", category: "compound", equipment: [.dumbbells, .homeBasic]),
        ExerciseTemplate(name: "Walking Lunge", focus: "Lower Hypertrophy", muscleGroup: "glutes", category: "compound", equipment: [.dumbbells, .bodyweightOnly, .homeBasic]),
        ExerciseTemplate(name: "Overhead Press", focus: "Upper Push", muscleGroup: "shoulders", category: "compound", equipment: [.gym, .dumbbells]),
        ExerciseTemplate(name: "Band Pull Apart", focus: "Upper Pull", muscleGroup: "shoulders", category: "isolation", equipment: [.homeBasic]),
        ExerciseTemplate(name: "Plank", focus: "Core Stability", muscleGroup: "core", category: "isolation", equipment: [.gym, .dumbbells, .homeBasic, .bodyweightOnly]),
        ExerciseTemplate(name: "Step-Up", focus: "Single Leg", muscleGroup: "glutes", category: "compound", equipment: [.dumbbells, .bodyweightOnly, .homeBasic]),
        ExerciseTemplate(name: "Glute Bridge", focus: "Posterior Chain", muscleGroup: "glutes", category: "isolation", equipment: [.bodyweightOnly, .homeBasic, .dumbbells]),
        ExerciseTemplate(name: "Hammer Curl", focus: "Arms", muscleGroup: "biceps", category: "isolation", equipment: [.gym, .dumbbells]),
        ExerciseTemplate(name: "Cable Triceps Pressdown", focus: "Arms", muscleGroup: "triceps", category: "isolation", equipment: [.gym]),
        ExerciseTemplate(name: "Bodyweight Calf Raise", focus: "Accessories", muscleGroup: "calves", category: "isolation", equipment: [.gym, .dumbbells, .homeBasic, .bodyweightOnly])
    ]

    static func buildPlan(profile: Profile) -> FullPlan {
        let weekInMesocycle = currentWeekInMesocycle()
        let phase = phase(for: weekInMesocycle)
        let nutrition = buildNutrition(profile: profile)
        let sleep = buildSleep(profile: profile)
        let workout = buildWorkout(profile: profile, phase: phase, weekInMesocycle: weekInMesocycle)

        return FullPlan(nutrition: nutrition, workout: workout, sleep: sleep)
    }

    private static func buildNutrition(profile: Profile) -> NutritionPlan {
        let sexOffset: Double
        switch profile.sexAtBirth {
        case .male:
            sexOffset = 5
        case .female:
            sexOffset = -161
        case .preferNot:
            sexOffset = -78
        }

        let bmr = Int((10 * Double(profile.weightKg)) + (6.25 * Double(profile.heightCm)) - (5 * Double(profile.age)) + sexOffset)
        let activityMultiplier: Double
        switch profile.activityLevel {
        case .sedentary:
            activityMultiplier = 1.2
        case .light:
            activityMultiplier = 1.375
        case .moderate:
            activityMultiplier = 1.55
        case .high:
            activityMultiplier = 1.725
        }

        let tdee = Int(Double(bmr) * activityMultiplier)
        let caloriesTarget: Int
        switch profile.goal {
        case .fatLoss:
            caloriesTarget = max(tdee - 350, 1400)
        case .muscleGain:
            caloriesTarget = tdee + 250
        case .strength:
            caloriesTarget = tdee + 120
        case .recomp:
            caloriesTarget = tdee
        }

        let protein = Int((profile.goal == .strength ? 2.1 : 1.9) * Double(profile.weightKg))
        let fat = Int(max(Double(profile.weightKg) * 0.8, 50))
        let carbCalories = caloriesTarget - (protein * 4) - (fat * 9)
        let carbs = max(carbCalories / 4, 100)
        let water = max(Double(profile.weightKg) * 0.035, 2.0)

        var notes = [
            "Calories are adjusted from local goal and activity assumptions.",
            "Protein is kept high to support recovery and lean mass retention."
        ]
        if !profile.allergies.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notes.append("Review meals around declared allergies: \(profile.allergies).")
        }
        if !profile.dietPreference.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notes.append("Diet preference noted: \(profile.dietPreference).")
        }

        return NutritionPlan(
            bmr: bmr,
            tdee: tdee,
            caloriesTarget: caloriesTarget,
            proteinG: protein,
            carbsG: carbs,
            fatG: fat,
            fiberG: max(25, profile.sessionMinutes / 2),
            waterLiters: (water * 10).rounded() / 10,
            notes: notes,
            mealTimingHints: [
                "Prioritize a protein-forward meal within two hours after training.",
                "Use a carbohydrate-rich meal before harder sessions.",
                "Keep hydration consistent through the day, not only around workouts."
            ]
        )
    }

    private static func buildSleep(profile: Profile) -> SleepPlan {
        let target = min(max(profile.sleepHours + (profile.stressLevel >= 4 ? 1 : 0), 7), 9)
        let bedtimeHour = max(21, 24 - target)
        let recoveryScore: String
        switch profile.stressLevel {
        case 1...2:
            recoveryScore = "High"
        case 3:
            recoveryScore = "Moderate"
        default:
            recoveryScore = "Recovery Focus Needed"
        }

        return SleepPlan(
            targetHours: target,
            bedtimeHint: String(format: "%02d:30 target bedtime", bedtimeHour),
            nudges: [
                "Stop caffeine at least eight hours before bedtime.",
                "Create a repeatable 20-minute wind-down routine.",
                "Keep training intensity aligned with current recovery."
            ],
            recoveryScore: recoveryScore
        )
    }

    private static func buildWorkout(profile: Profile, phase: PeriodizationPhase, weekInMesocycle: Int) -> WorkoutPlan {
        let split = splitTemplate(daysPerWeek: profile.daysPerWeek)
        let params = goalParameters(goal: profile.goal, phase: phase)
        let allowedExercises = exercisePool.filter { $0.equipment.contains(profile.equipment) || profile.equipment == .gym && $0.equipment.contains(.gym) }

        let workoutDays: [WorkoutDay] = split.enumerated().map { index, template in
            let chosen = selectExercises(from: allowedExercises, focus: template.focus, fallbackIndex: index)
            let exercises = chosen.map { template in
                Exercise(
                    name: template.name,
                    sets: template.category == "compound" ? params.compoundSets : params.isolationSets,
                    reps: template.category == "compound" ? params.compoundReps : params.isolationReps,
                    restSec: template.category == "compound" ? params.compoundRestSec : params.isolationRestSec,
                    intensityHint: params.intensityHint,
                    muscleGroup: template.muscleGroup,
                    category: template.category,
                    tempo: params.tempo
                )
            }

            return WorkoutDay(
                name: template.name,
                focus: template.focus,
                warmup: [
                    "5 minutes of light cardio",
                    "Dynamic mobility for \(template.focus.lowercased())",
                    "2 ramp-up sets before the first compound movement"
                ],
                exercises: exercises,
                estimatedMinutes: min(profile.sessionMinutes, 35 + exercises.count * 8),
                targetMuscles: Array(Set(exercises.map(\.muscleGroup))).sorted()
            )
        }

        let volumeTargets = [
            MuscleVolumeTarget(muscle: "Chest", setsPerWeek: params.largeMuscleSets, frequency: max(1, profile.daysPerWeek / 2)),
            MuscleVolumeTarget(muscle: "Back", setsPerWeek: params.largeMuscleSets, frequency: max(1, profile.daysPerWeek / 2)),
            MuscleVolumeTarget(muscle: "Legs", setsPerWeek: params.largeMuscleSets + 2, frequency: max(1, profile.daysPerWeek / 2)),
            MuscleVolumeTarget(muscle: "Shoulders", setsPerWeek: params.smallMuscleSets, frequency: max(1, profile.daysPerWeek / 3)),
            MuscleVolumeTarget(muscle: "Core", setsPerWeek: max(4, profile.daysPerWeek * 2), frequency: profile.daysPerWeek)
        ]

        var safetyNotes = [
            "Leave one to three reps in reserve on most working sets.",
            "Stop or modify movements that aggravate pain."
        ]
        if !profile.limitations.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            safetyNotes.append("Known limitation: \(profile.limitations).")
        }

        return WorkoutPlan(
            splitName: split.map(\.name).joined(separator: " / "),
            days: workoutDays,
            progressionRule: params.progressionRule,
            safetyNotes: safetyNotes,
            phase: phase,
            weekInMesocycle: weekInMesocycle,
            mesocycleLength: mesocycleLength,
            weeklyVolume: volumeTargets,
            periodizationNotes: [
                "Weeks 1-2 accumulate work with steady volume.",
                "Week 3 biases intensity and tighter execution.",
                "Week 4 deloads volume to keep recovery ahead of fatigue."
            ],
            deloadStrategy: "Reduce total sets by roughly 40-50% and keep effort no higher than RPE 6."
        )
    }

    private static func currentWeekInMesocycle() -> Int {
        let calendar = Calendar(identifier: .iso8601)
        let week = calendar.component(.weekOfYear, from: Date())
        return ((week - 1) % mesocycleLength) + 1
    }

    private static func phase(for week: Int) -> PeriodizationPhase {
        switch week {
        case 4:
            return .deload
        case 3:
            return .intensification
        default:
            return .accumulation
        }
    }

    private static func splitTemplate(daysPerWeek: Int) -> [(name: String, focus: String)] {
        switch daysPerWeek {
        case 1:
            return [("Full Body", "Full Body")]
        case 2:
            return [("Day 1", "Upper Push"), ("Day 2", "Lower Strength")]
        case 3:
            return [("Push", "Upper Push"), ("Pull", "Upper Pull"), ("Legs", "Lower Strength")]
        case 4:
            return [("Upper A", "Upper Push"), ("Lower A", "Lower Strength"), ("Upper B", "Upper Pull"), ("Lower B", "Lower Hypertrophy")]
        default:
            return [("Push", "Upper Push"), ("Pull", "Upper Pull"), ("Legs", "Lower Strength"), ("Upper Blend", "Arms"), ("Lower Blend", "Posterior Chain")]
        }
    }

    private static func selectExercises(from templates: [ExerciseTemplate], focus: String, fallbackIndex: Int) -> [ExerciseTemplate] {
        let matching = templates.filter { $0.focus == focus }
        if matching.count >= 4 {
            return Array(matching.prefix(4))
        }

        let additional = templates
            .filter { $0.focus != focus }
            .dropFirst(fallbackIndex % max(1, templates.count))
        return Array((matching + additional).prefix(4))
    }

    private static func goalParameters(goal: Goal, phase: PeriodizationPhase) -> (compoundReps: String, isolationReps: String, compoundSets: Int, isolationSets: Int, compoundRestSec: Int, isolationRestSec: Int, intensityHint: String, tempo: String?, largeMuscleSets: Int, smallMuscleSets: Int, progressionRule: String) {
        let multiplier: Double
        switch phase {
        case .accumulation:
            multiplier = 1.0
        case .intensification:
            multiplier = 0.9
        case .deload:
            multiplier = 0.6
        }

        let base: (String, String, Int, Int, Int, Int, String, String?, Int, Int, String)
        switch goal {
        case .strength:
            base = ("4-6", "6-10", 4, 3, 180, 120, phase == .deload ? "RPE 5-6" : "RPE 8-9", "3-1-1-0", 8, 6, "Add 2.5-5% load when all reps are completed cleanly. Deload every 4th week.")
        case .muscleGain:
            base = ("6-10", "10-15", 4, 3, 120, 75, phase == .deload ? "RPE 5-6" : "RPE 7-8", "2-1-2-0", 14, 10, "Progress by adding reps first, then load once the top of the range is stable.")
        case .fatLoss:
            base = ("8-12", "12-15", 3, 2, 90, 60, phase == .deload ? "RPE 5-6" : "RPE 6-7", nil, 10, 8, "Keep density high and progress with cleaner execution or shorter rest before load increases.")
        case .recomp:
            base = ("6-10", "10-14", 4, 3, 120, 75, phase == .deload ? "RPE 5-6" : "RPE 7-8", "2-0-2-0", 12, 8, "Use small weekly load jumps while maintaining technique and repeatability.")
        }

        return (
            compoundReps: base.0,
            isolationReps: base.1,
            compoundSets: max(1, Int((Double(base.2) * multiplier).rounded())),
            isolationSets: max(1, Int((Double(base.3) * multiplier).rounded())),
            compoundRestSec: base.4,
            isolationRestSec: base.5,
            intensityHint: base.6,
            tempo: base.7,
            largeMuscleSets: max(4, Int((Double(base.8) * multiplier).rounded())),
            smallMuscleSets: max(4, Int((Double(base.9) * multiplier).rounded())),
            progressionRule: base.10
        )
    }
}

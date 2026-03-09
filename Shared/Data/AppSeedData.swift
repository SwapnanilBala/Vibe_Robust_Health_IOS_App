import Foundation

enum AppSeedData {
    static let coachSpecialties = CoachSpecialty.allCases

    static let coachDirectory: [CoachProfile] = [
        CoachProfile(name: "Mason Reid", email: "mason.reid@fitcoachhub.com", specialties: [.weightLifting, .powerLifting], monthlyFeeUsd: 149, yearlyFeeUsd: 1490),
        CoachProfile(name: "Ava Coleman", email: "ava.coleman@fitcoachhub.com", specialties: [.bodyBuilding, .weightLifting], monthlyFeeUsd: 179, yearlyFeeUsd: 1790),
        CoachProfile(name: "Ethan Brooks", email: "ethan.brooks@fitcoachhub.com", specialties: [.crossfit, .aerobics], monthlyFeeUsd: 129, yearlyFeeUsd: 1290),
        CoachProfile(name: "Lila Foster", email: "lila.foster@fitcoachhub.com", specialties: [.aerobics, .bodyBuilding], monthlyFeeUsd: 119, yearlyFeeUsd: 1190),
        CoachProfile(name: "Noah Singh", email: "noah.singh@fitcoachhub.com", specialties: [.powerLifting, .crossfit], monthlyFeeUsd: 169, yearlyFeeUsd: 1690),
        CoachProfile(name: "Sofia Kim", email: "sofia.kim@fitcoachhub.com", specialties: [.weightLifting, .aerobics], monthlyFeeUsd: 139, yearlyFeeUsd: 1390)
    ]

    static let trainerDirectory: [Trainer] = [
        Trainer(id: "trainer-1", name: "Mason Reid", email: "mason.reid@fitcoachhub.com", credential: "rh-trainer-2026"),
        Trainer(id: "trainer-2", name: "Ava Coleman", email: "ava.coleman@fitcoachhub.com", credential: "rh-trainer-2026"),
        Trainer(id: "trainer-3", name: "Ethan Brooks", email: "ethan.brooks@fitcoachhub.com", credential: "rh-trainer-2026")
    ]

    static let clientDirectory: [ClientDirectoryItem] = [
        ClientDirectoryItem(fullName: "Jordan Patel", email: "jordan.patel@robusthealth.app", phone: "+1-917-555-0142", goal: .fatLoss, daysPerWeek: 4, sessionMinutes: 45, equipment: .dumbbells, assignedTrainerEmail: "ava.coleman@fitcoachhub.com"),
        ClientDirectoryItem(fullName: "Mia Thompson", email: "mia.thompson@robusthealth.app", phone: "+1-646-555-0199", goal: .strength, daysPerWeek: 5, sessionMinutes: 60, equipment: .gym, assignedTrainerEmail: "mason.reid@fitcoachhub.com")
    ]
}

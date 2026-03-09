import Foundation

enum LocalStoreKey {
    static let profiles = "rh_profiles_v1"
    static let plans = "rh_plans_v1"
    static let members = "rh_members_v1"
    static let activeProfileId = "rh_active_profile_id_v1"
    static let activeMemberId = "rh_active_member_id_v1"
    static let activeTrainerId = "rh_active_trainer_id_v1"
}

final class LocalDatabase {
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func getProfiles() -> [StoredProfile] {
        read(LocalStoreKey.profiles, fallback: [])
    }

    func saveProfiles(_ profiles: [StoredProfile]) {
        write(LocalStoreKey.profiles, value: profiles)
    }

    func getPlans() -> [StoredPlan] {
        read(LocalStoreKey.plans, fallback: [])
    }

    func savePlans(_ plans: [StoredPlan]) {
        write(LocalStoreKey.plans, value: plans)
    }

    func getMembers() -> [Member] {
        read(LocalStoreKey.members, fallback: [])
    }

    func saveMembers(_ members: [Member]) {
        write(LocalStoreKey.members, value: members)
    }

    func getActiveProfileId() -> String? {
        defaults.string(forKey: LocalStoreKey.activeProfileId)
    }

    func setActiveProfileId(_ profileId: String?) {
        defaults.set(profileId, forKey: LocalStoreKey.activeProfileId)
    }

    func getActiveMemberId() -> String? {
        defaults.string(forKey: LocalStoreKey.activeMemberId)
    }

    func setActiveMemberId(_ memberId: String?) {
        defaults.set(memberId, forKey: LocalStoreKey.activeMemberId)
    }

    func getActiveTrainerId() -> String? {
        defaults.string(forKey: LocalStoreKey.activeTrainerId)
    }

    func setActiveTrainerId(_ trainerId: String?) {
        defaults.set(trainerId, forKey: LocalStoreKey.activeTrainerId)
    }

    func makeId(prefix: String) -> String {
        let random = UUID().uuidString.prefix(8)
        return "\(prefix)_\(Int(Date().timeIntervalSince1970))_\(random)"
    }

    private func read<T: Decodable>(_ key: String, fallback: T) -> T {
        guard let data = defaults.data(forKey: key) else { return fallback }
        return (try? decoder.decode(T.self, from: data)) ?? fallback
    }

    private func write<T: Encodable>(_ key: String, value: T) {
        guard let data = try? encoder.encode(value) else { return }
        defaults.set(data, forKey: key)
    }
}

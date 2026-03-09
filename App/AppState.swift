import SwiftUI

enum AppRoute: Hashable {
    case onboarding
    case plan
    case memberLogin
    case memberDashboard
    case trainerLogin
    case trainerClients
    case pricing
}

@MainActor
final class AppState: ObservableObject {
    @Published var path: [AppRoute] = []

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    func replaceCurrent(with route: AppRoute) {
        if path.isEmpty {
            path = [route]
        } else {
            path[path.count - 1] = route
        }
    }

    func resetToRoot() {
        path.removeAll()
    }
}

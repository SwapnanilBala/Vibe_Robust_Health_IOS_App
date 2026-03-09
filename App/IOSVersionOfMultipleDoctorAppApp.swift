import SwiftUI

@main
struct IOSVersionOfMultipleDoctorAppApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(container)
        }
    }
}

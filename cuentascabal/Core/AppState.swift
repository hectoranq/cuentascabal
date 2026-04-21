import Foundation
internal import Combine
@MainActor
final class AppState: ObservableObject {

    @Published var currentUser: GoogleUser?

    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: "onboardingComplete") }
    }

    var isAuthenticated: Bool { currentUser != nil }
    var needsOnboarding: Bool { isAuthenticated && !hasCompletedOnboarding }

    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "onboardingComplete")
    }
}


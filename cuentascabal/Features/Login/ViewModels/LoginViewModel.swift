import SwiftUI
import Foundation
import UIKit
internal import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: AuthenticationServiceProtocol
    private let appState: AppState

    init(service: AuthenticationServiceProtocol = AuthenticationService(), appState: AppState) {
        self.service = service
        self.appState = appState
        Task { await restoreSession() }
    }

    // MARK: - Public

    func signIn(presenting viewController: UIViewController) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let user = try await service.signIn(presenting: viewController)
                appState.currentUser = user
            } catch AuthError.cancelled {
                // User dismissed the sign-in flow — no error message needed
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    // MARK: - Private

    private func restoreSession() async {
        do {
            if let user = try await service.restorePreviousSignIn() {
                appState.currentUser = user
            }
        } catch {
            // Silent failure — user sees the login screen
        }
    }
}

import Foundation
import UIKit
import GoogleSignIn

// MARK: - Protocol

protocol AuthenticationServiceProtocol {
    func signIn(presenting viewController: UIViewController) async throws -> GoogleUser
    func restorePreviousSignIn() async throws -> GoogleUser?
    func signOut()
}

// MARK: - Error

enum AuthError: LocalizedError {
    case missingUserData
    case cancelled
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .missingUserData:
            return "No se pudo obtener la información del usuario de Google."
        case .cancelled:
            return nil
        case .underlying(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Implementation

final class AuthenticationService: AuthenticationServiceProtocol {

    func signIn(presenting viewController: UIViewController) async throws -> GoogleUser {
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            return try map(result.user)
        } catch let error as NSError
            where error.domain == kGIDSignInErrorDomain && error.code == GIDSignInError.canceled.rawValue {
            throw AuthError.cancelled
        } catch {
            throw AuthError.underlying(error)
        }
    }

    func restorePreviousSignIn() async throws -> GoogleUser? {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else { return nil }
        do {
            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            return try map(user)
        } catch {
            throw AuthError.underlying(error)
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    // MARK: - Private

    private func map(_ gidUser: GIDGoogleUser) throws -> GoogleUser {
        guard let email = gidUser.profile?.email,
              let displayName = gidUser.profile?.name else {
            throw AuthError.missingUserData
        }
        return GoogleUser(
            id: gidUser.userID ?? UUID().uuidString,
            email: email,
            displayName: displayName,
            avatarURL: gidUser.profile?.imageURL(withDimension: 200)
        )
    }
}

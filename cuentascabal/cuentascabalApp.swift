//
//  cuentascabalApp.swift
//  cuentascabal
//
//  Created by ivan aquino on 13/4/26.
//

import SwiftUI
import SwiftData

@main
struct cuentascabalApp: App {

    @StateObject private var appState = AppState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.hasCompletedOnboarding {
                    HomeView(viewModel: HomeViewModel(appState: appState))
                } else if !appState.isAuthenticated {
                    LoginView(viewModel: LoginViewModel(appState: appState))
                } else {
                    OnboardingContainerView(
                        viewModel: OnboardingViewModel(appState: appState)
                    )
                }
            }
            .animation(.easeInOut(duration: 0.35), value: appState.hasCompletedOnboarding)
            .animation(.easeInOut(duration: 0.35), value: appState.isAuthenticated)
            .environmentObject(appState)
            .onOpenURL { url in
                // GoogleSignIn not available: missing dependency
                // GIDSignIn.sharedInstance.handle(url)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}


import SwiftUI
import GoogleSignInSwift

struct LoginView: View {

    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject private var appState: AppState
    @State private var showOnboarding = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // MARK: Branding
            VStack(spacing: 12) {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.gray.opacity(0.5))

                Text("Cuentas Cabal")
                    .font(.largeTitle.bold())

                Text("Gestiona tus cuentas fácilmente")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // MARK: Ir a Onboarding
            Button {
                showOnboarding = true
            } label: {
                Text("Continuar →")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.headerBackground)
                    .clipShape(Capsule())
            }

            // MARK: Google Sign-In
           // GoogleSignInButton(scheme: .light, style: .wide, action: signIn)
           //     .frame(height: 50)
           //     .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 8)
            }

            Spacer()
        }
        .padding(.horizontal, 32)
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingContainerView(
                viewModel: OnboardingViewModel(appState: appState)
            )
        }
        .alert(
            "Error al iniciar sesión",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Private

    private func signIn() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootVC = windowScene.keyWindow?.rootViewController
        else { return }
        viewModel.signIn(presenting: rootVC)
    }
}

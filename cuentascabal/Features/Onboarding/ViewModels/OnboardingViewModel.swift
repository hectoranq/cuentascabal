import Foundation
internal import Combine
@MainActor
final class OnboardingViewModel: ObservableObject {

    // MARK: - Published

    @Published var currentStep: Int = 1
    @Published var accountName: String = ""
    @Published var selectedBalanceIndex: Int = 50

    // MARK: - Constants

    let totalSteps = 2
    let balanceValues: [Double] = stride(from: 0.0, through: 10_000.0, by: 50.0).map { $0 }

    // MARK: - Computed

    var selectedBalance: Double { balanceValues[selectedBalanceIndex] }

    var progressFraction: Double {
        Double(currentStep) / Double(totalSteps)
    }

    var isAccountNameValid: Bool {
        !accountName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Private

    private let appState: AppState

    // MARK: - Init

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: - Actions

    func nextStep() {
        guard currentStep < totalSteps else {
            completeOnboarding()
            return
        }
        currentStep += 1
    }

    func skip() {
        completeOnboarding()
    }

    func addAnotherAccount() {
        accountName = ""
        selectedBalanceIndex = 50
        currentStep = 1
    }

    func finishOnboarding() {
        completeOnboarding()
    }

    // MARK: - Private

    private func completeOnboarding() {
        appState.hasCompletedOnboarding = true
    }
}


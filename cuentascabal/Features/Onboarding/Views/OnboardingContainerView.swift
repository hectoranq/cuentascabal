import SwiftUI

struct OnboardingContainerView: View {

    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.screenBackground.ignoresSafeArea()

                Group {
                    if viewModel.currentStep == 1 {
                        AccountNameStepView(viewModel: viewModel)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    } else {
                        BalanceStepView(viewModel: viewModel)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.currentStep > 1 {
                        Button {
                            viewModel.currentStep -= 1
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundStyle(Color.brandGreen)
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Onboarding")
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("HELP") {}
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.brandGreen)
                }
            }
        }
    }
}

#Preview {
    OnboardingContainerView(viewModel: OnboardingViewModel(appState: AppState()))
}

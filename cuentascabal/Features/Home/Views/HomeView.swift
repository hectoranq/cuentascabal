import SwiftUI

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack(spacing: 0) {
            // ── Scrollable content ────────────────────────────────────────
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeHeaderView(viewModel: viewModel)
                    AccountsCarouselView(viewModel: viewModel)
                        .padding(.top, 28)
                    CategoriesGridView(viewModel: viewModel)
                        .padding(.top, 28)
                    RecentExpensesView(viewModel: viewModel)
                        .padding(.top, 28)
                        .padding(.bottom, 24)
                }
            }
            .ignoresSafeArea(edges: .top)

            // ── Tab bar — always pinned to bottom ─────────────────────────
            HomeTabBar(
                selectedTab: $viewModel.selectedTab,
                onMicTap: { viewModel.showVoiceInput = true },
                onCameraTap: { viewModel.showCameraCapture = true }
            )
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $viewModel.showVoiceInput) {
            VoiceInputView(
                viewModel: VoiceInputViewModel(
                    onDismiss: { viewModel.showVoiceInput = false }
                )
            )
        }
        .fullScreenCover(isPresented: $viewModel.showCameraCapture) {
            ReceiptCaptureView(
                viewModel: ReceiptCaptureViewModel(
                    onDismiss: { viewModel.showCameraCapture = false }
                )
            )
        }
    }
}


// MARK: - Preview
#Preview {
    HomeView(viewModel: HomeViewModel(appState: AppState()))
}

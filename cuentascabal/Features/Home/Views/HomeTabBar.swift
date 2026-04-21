import SwiftUI

struct HomeTabBar: View {

    @Binding var selectedTab: HomeTab
    var onMicTap: () -> Void = {}
    var onCameraTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home,     icon: "house.fill",       label: "Home")
            tabButton(.insights, icon: "chart.bar.fill",   label: "Insights")

            // Mic — large central black pill
            Button {
                selectedTab = .mic
                onMicTap()
            } label: {
                ZStack {
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 56, height: 56)
                    Image(systemName: "mic.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -8)

            // Camera — blue circle
            Button {
                selectedTab = .camera
                onCameraTap()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 48, height: 48)
                    Image(systemName: "camera.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -4)

           // tabButton(.cards,    icon: "creditcard.fill",  label: "Cards")
            tabButton(.settings, icon: "gearshape.fill",   label: "Settings")
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            Color(.systemBackground)
                .shadow(.drop(color: .black.opacity(0.08), radius: 12, y: -4))
        )
    }

    // MARK: - Regular tab button

    @ViewBuilder
    private func tabButton(_ tab: HomeTab, icon: String, label: String) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(selectedTab == tab ? .primary : .secondary)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(selectedTab == tab ? .primary : .secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

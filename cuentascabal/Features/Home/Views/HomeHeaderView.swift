import SwiftUI

struct HomeHeaderView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.headerBackground.ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: 0) {
                // ── Top row: label + avatar ───────────────────────────────
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Balance")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                        Text(viewModel.formatted(viewModel.totalBalance))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .overlay {
                            Text(viewModel.userInitials)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)

                // ── Finance mode toggle ───────────────────────────────────
                FinanceModeToggle(selected: $viewModel.financeMode)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                // ── Cash Flow card ────────────────────────────────────────
                CashFlowCard(projection: viewModel.cashFlowProjection,
                             formatter: viewModel.formatted)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Finance Mode Toggle

private struct FinanceModeToggle: View {
    @Binding var selected: FinanceMode

    var body: some View {
        HStack(spacing: 0) {
            ForEach(FinanceMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { selected = mode }
                } label: {
                    Text(mode.label)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selected == mode ? .black : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selected == mode
                                ? Color.white
                                : Color.clear
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }
}

// MARK: - Cash Flow Card

private struct CashFlowCard: View {
    let projection: Double
    let formatter: (Double) -> String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("CASH FLOW PROJECTION")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .kerning(0.5)
                HStack(spacing: 4) {
                    Text("+\(formatter(projection))")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.green)
                    Text("this month")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            Spacer()
            // Bar chart icon
            HStack(alignment: .bottom, spacing: 3) {
                ForEach([0.4, 0.6, 0.5, 0.8, 1.0], id: \.self) { h in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.5 + h * 0.4))
                        .frame(width: 6, height: 28 * h)
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

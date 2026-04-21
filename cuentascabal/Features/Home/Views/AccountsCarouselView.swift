import SwiftUI

struct AccountsCarouselView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ── Section header ────────────────────────────────────────────
            HStack {
                Text("Mis Cuentas")
                    .font(.title3.weight(.bold))
                Spacer()
                Button("+ Add") {}
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.brandGreen)
            }
            .padding(.horizontal, 24)

            // ── Horizontal scroll ─────────────────────────────────────────
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(viewModel.accounts) { account in
                        AccountCard(account: account, formatter: viewModel.formatted)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Account Card

private struct AccountCard: View {
    let account: Account
    let formatter: (Double) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(account.name)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .kerning(0.3)
                .lineLimit(1)

            Text(formatter(account.amount))
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            HStack(spacing: 6) {
                Circle()
                    .fill(account.bankColor)
                    .frame(width: 8, height: 8)
                Text(account.bankName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(width: 160, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
}

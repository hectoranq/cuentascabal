import SwiftUI

struct RecentExpensesView: View {

    @ObservedObject var viewModel: HomeViewModel

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // ── Section header ────────────────────────────────────────────
            HStack {
                Text("Recent Expenses")
                    .font(.title3.weight(.bold))
                Spacer()
                Button("See All") {}
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.brandGreen)
            }
            .padding(.horizontal, 24)

            // ── Expense rows ──────────────────────────────────────────────
            VStack(spacing: 0) {
                ForEach(viewModel.recentExpenses) { expense in
                    ExpenseRow(expense: expense, formatter: viewModel.formatted)
                    if expense.id != viewModel.recentExpenses.last?.id {
                        Divider().padding(.leading, 76)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Expense Row

private struct ExpenseRow: View {
    let expense: Expense
    let formatter: (Double) -> String

    private var dateLabel: String {
        let cal = Calendar.current
        guard cal.isDateInToday(expense.date) else {
            let f = DateFormatter()
            f.dateStyle = .short
            return f.string(from: expense.date)
        }
        return "Today"
    }

    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            ZStack {
                Circle()
                    .fill(expense.avatarColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                Text(expense.avatarInitials)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(expense.avatarColor)
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(expense.merchantName)
                    .font(.subheadline.weight(.semibold))
                HStack(spacing: 4) {
                    Text(expense.category)
                        .foregroundStyle(.secondary)
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(dateLabel)
                        .foregroundStyle(.secondary)
                    Text(expense.bankName)
                        .foregroundStyle(expense.bankColor)
                }
                .font(.caption)
            }

            Spacer()

            // Amount
            Text(formatter(expense.amount))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
}

import Foundation
import SwiftUI
internal import Combine

// MARK: - Supporting enums

enum HomeTab: CaseIterable {
    case home, insights, mic, camera, cards, settings
}

enum FinanceMode: CaseIterable {
    case personal, negocio

    var label: String {
        switch self {
        case .personal: return "Mis Finanzas"
        case .negocio:  return "Modo Negocio"
        }
    }
}

// MARK: - ViewModel

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: Published
    @Published var selectedTab: HomeTab = .home
    @Published var financeMode: FinanceMode = .personal
    @Published var showVoiceInput: Bool = false
    @Published var showCameraCapture: Bool = false

    @Published var accounts: [Account] = [
        Account(name: "GASTOS ESCOLARES", amount: 1200.00, bankName: "Banco A", bankColor: .blue),
        Account(name: "GASTOS DEL MES",   amount: 2450.00, bankName: "Banco B", bankColor: .green),
        Account(name: "DIARIO",           amount: 1560.00, bankName: "Banco C", bankColor: .pink)
    ]

    @Published var categories: [Category] = [
        Category(name: "Home",         bankName: "Banco A",amountCategoria: "$345.00", bankColor: .blue,
                 iconName: "house.fill",        iconColor: .purple),
        Category(name: "Food",         bankName: "Banco C",amountCategoria: "$347.00", bankColor: .pink,
                 iconName: "book.fill",         iconColor: .orange),
        Category(name: "Personal Exp.", bankName: "Banco C",amountCategoria: "$934.00", bankColor: .pink,
                 iconName: "bag.fill",          iconColor: .pink),
        Category(name: "Income",       bankName: "Banco B",amountCategoria: "$1034.00", bankColor: .green,
                 iconName: "dollarsign.circle.fill", iconColor: .green)
    ]

    @Published var recentExpenses: [Expense] = [
        Expense(merchantName: "Starbucks Coffee",
                category: "Food", date: Date(),
                bankName: "Banco C", bankColor: .pink,
                amount: -5.40,
                avatarInitials: "FD", avatarColor: .orange)
    ]

    // MARK: Computed
    var totalBalance: Double { accounts.reduce(0) { $0 + $1.amount } }
    var cashFlowProjection: Double { 1120.00 }

    var userInitials: String {
        appState.currentUser.map { user in
            let parts = user.displayName.split(separator: " ")
            let first = parts.first?.prefix(1) ?? ""
            let last  = parts.dropFirst().first?.prefix(1) ?? ""
            return "\(first)\(last)".uppercased()
        } ?? "JD"
    }

    // MARK: Private
    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    // MARK: Formatters
    let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencySymbol = "$"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()

    func formatted(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

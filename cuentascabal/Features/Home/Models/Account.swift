import SwiftUI

struct Account: Identifiable {
    let id: UUID
    let name: String
    let amount: Double
    let bankName: String
    let bankColor: Color

    init(id: UUID = UUID(), name: String, amount: Double, bankName: String, bankColor: Color) {
        self.id = id
        self.name = name
        self.amount = amount
        self.bankName = bankName
        self.bankColor = bankColor
    }
}

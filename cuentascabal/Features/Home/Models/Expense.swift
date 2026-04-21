import SwiftUI

struct Expense: Identifiable {
    let id: UUID
    let merchantName: String
    let category: String
    let date: Date
    let bankName: String
    let bankColor: Color
    let amount: Double
    let avatarInitials: String
    let avatarColor: Color

    init(id: UUID = UUID(), merchantName: String, category: String, date: Date,
         bankName: String, bankColor: Color, amount: Double,
         avatarInitials: String, avatarColor: Color) {
        self.id = id
        self.merchantName = merchantName
        self.category = category
        self.date = date
        self.bankName = bankName
        self.bankColor = bankColor
        self.amount = amount
        self.avatarInitials = avatarInitials
        self.avatarColor = avatarColor
    }
}

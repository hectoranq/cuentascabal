import SwiftUI

struct Category: Identifiable {
    let id: UUID
    let name: String
    let bankName: String
    let amountCategoria: String
    let bankColor: Color
    let iconName: String
    let iconColor: Color

    init(id: UUID = UUID(), name: String, bankName: String,amountCategoria: String, bankColor: Color,
         iconName: String, iconColor: Color) {
        self.id = id
        self.name = name
        self.bankName = bankName
        self.amountCategoria = amountCategoria
        self.bankColor = bankColor
        self.iconName = iconName
        self.iconColor = iconColor
    }
}

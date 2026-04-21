import SwiftUI

struct CategoriesGridView: View {

    @ObservedObject var viewModel: HomeViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Categories")
                .font(.title3.weight(.bold))
                .padding(.horizontal, 24)

            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(viewModel.categories) { category in
                    CategoryCard(category: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Category Card

private struct CategoryCard: View {
    let category: Category

    var body: some View {
        VStack(spacing: 10) {
            HStack{
                ZStack {
                    Circle()
                        .fill(category.iconColor.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: category.iconName)
                        .font(.system(size: 22))
                        .foregroundStyle(category.iconColor)
                }

                Text(category.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
           
            Text(category.amountCategoria)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Text(category.bankName)
                .font(.caption)
                .foregroundStyle(category.bankColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
}


#Preview {
    CategoryCard(category: Category(name: "Home",         bankName: "Banco A",amountCategoria: "$430.00", bankColor: .blue,iconName: "house.fill", iconColor: .purple))
}

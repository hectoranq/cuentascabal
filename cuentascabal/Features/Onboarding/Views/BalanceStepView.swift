import SwiftUI

struct BalanceStepView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: Hero title
                    Text("¿Que saldo actualmente tiene en esa cuenta?")
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .padding(.top, 32)
                        .padding(.horizontal, 28)

                    // MARK: Subtitle
                    Text("Indique el monto disponible al día de hoy.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .padding(.horizontal, 40)

                    // MARK: Picker card
                    AmountPickerCard(viewModel: viewModel)
                        .padding(.horizontal, 20)
                        .padding(.top, 36)

                    Spacer(minLength: 32)
                }
            }

            // MARK: Bottom actions
            VStack(spacing: 12) {
                // "+ Cuenta más" primary
                Button {
                    viewModel.addAnotherAccount()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle")
                        Text("+ Cuenta más")
                    }
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.headerBackground)
                    .clipShape(Capsule())
                }

                // "Hasta aquí" secondary
                Button {
                    viewModel.finishOnboarding()
                } label: {
                    Text("Hasta aquí")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color.screenBackground)
        }
    }
}

// MARK: - Amount Picker Card

private struct AmountPickerCard: View {

    @ObservedObject var viewModel: OnboardingViewModel
    private let rowHeight: CGFloat = 56

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BOL...")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            // Drum-roll
            DrumRollPicker(
                values: viewModel.balanceValues,
                selectedIndex: $viewModel.selectedBalanceIndex,
                rowHeight: rowHeight
            )
            .frame(height: rowHeight * 3)
            .clipped()

            // Hint
            HStack(spacing: 4) {
                Image(systemName: "pencil")
                    .font(.caption2)
                Text("DESLIZA PARA AJUSTAR")
                    .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Drum Roll Picker

private struct DrumRollPicker: View {

    let values: [Double]
    @Binding var selectedIndex: Int
    let rowHeight: CGFloat

    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    // Top padding so first item can center
                    Color.clear.frame(height: rowHeight)

                    ForEach(values.indices, id: \.self) { idx in
                        let isSelected = idx == selectedIndex
                        Text(formatted(values[idx]))
                            .font(isSelected
                                  ? .system(size: 40, weight: .bold)
                                  : .system(size: 28, weight: .regular))
                            .foregroundStyle(isSelected ? Color.headerBackground : Color.secondary.opacity(0.45))
                            .frame(maxWidth: .infinity)
                            .frame(height: rowHeight)
                            .overlay(alignment: .bottom) {
                                if isSelected {
                                    Rectangle()
                                        .fill(Color.headerBackground)
                                        .frame(height: 2)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .id(idx)
                            .scrollTransition(axis: .vertical) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.3)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.85)
                            }
                    }

                    // Bottom padding so last item can center
                    Color.clear.frame(height: rowHeight)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding(
                get: { selectedIndex },
                set: { newVal in
                    if let v = newVal { selectedIndex = v }
                }
            ))
            .onAppear {
                proxy.scrollTo(selectedIndex, anchor: .center)
            }
        }
    }

    private func formatted(_ value: Double) -> String {
        formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

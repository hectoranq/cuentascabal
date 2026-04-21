import SwiftUI

struct AccountNameStepView: View {

    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {

            // ── Scrollable content ────────────────────────────────────────
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Progress header ───────────────────────────────────
                    ProgressHeaderView(
                        currentStep: viewModel.currentStep,
                        totalSteps: 2
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    // ── Hero title ────────────────────────────────────────
                    Text("¿Como se llamaría tu cuenta\n(Yape, Altoke, Mercantil, bcp)?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color.headerBackground)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    // ── Subtitle ──────────────────────────────────────────
                    Text("Asigna un nombre que te ayude a identificar rápidamente el origen de tus fondos. Puede ser el nombre de tu banco o billetera digital favorita.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        .padding(.top, 20)

                    // ── Form card ─────────────────────────────────────────
                    VStack(alignment: .leading, spacing: 16) {

                        Text("NOMBRE DE LA CUENTA")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .kerning(0.5)

                        TextField("Ej. Mi cuenta BCP", text: $viewModel.accountName)
                            .padding(14)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Info card
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "info.circle")
                                .foregroundStyle(Color.brandGreen)
                            Text("Usaremos este nombre para organizar tus gráficos de gastos y metas de ahorro. Puedes cambiarlo después en los ajustes.")
                                .font(.footnote)
                                .foregroundStyle(Color.brandGreen.opacity(0.85))
                        }
                        .padding(14)
                        .background(Color.infoCardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(20)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .padding(.bottom, 32)
                }
            }
            .scrollBounceBehavior(.basedOnSize)

            // ── Bottom actions — siempre fijos al fondo ───────────────────
            VStack(spacing: 12) {
                Button {
                    viewModel.nextStep()
                } label: {
                    HStack {
                        Text("Siguiente")
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        viewModel.isAccountNameValid
                            ? Color.headerBackground
                            : Color.headerBackground.opacity(0.35)
                    )
                    .clipShape(Capsule())
                }
                .disabled(!viewModel.isAccountNameValid)

               
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .padding(.bottom, 32)
            .background(Color.screenBackground)
        }
    }
}

// MARK: - Progress Header
struct ProgressHeaderView: View {
    let currentStep: Int
    let totalSteps: Int

    private var progress: Double { Double(currentStep) / Double(totalSteps) }
    private var percentText: String { "\(Int(progress * 100))% completado" }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("PASO \(currentStep) DE \(totalSteps)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.headerBackground)
                    .kerning(0.5)
                Spacer()
                Text(percentText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.headerBackground)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.headerBackground.opacity(0.2))
                        .frame(height: 4)
                    Capsule().fill(Color.headerBackground)
                        .frame(width: geo.size.width * progress, height: 4)
                }
            }
            .frame(height: 4)
        }
    }
}

#Preview {
    AccountNameStepView(viewModel: OnboardingViewModel(appState: AppState()))
        .background(Color.screenBackground)
}

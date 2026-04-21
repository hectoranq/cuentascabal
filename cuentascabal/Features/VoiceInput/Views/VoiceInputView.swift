import SwiftUI

struct VoiceInputView: View {

    @StateObject var viewModel: VoiceInputViewModel

    private let screenBg = Color(red: 0.075, green: 0.098, blue: 0.141)
    private let cardBg   = Color(red: 0.118, green: 0.145, blue: 0.200)
    private let teal     = Color(red: 0, green: 0.788, blue: 0.647)

    var body: some View {
        ZStack {
            screenBg.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Title ───────────────────────────────────────────────
                Text(viewModel.isListening ? "Escuchando..." : "Iniciando...")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.top, 80)

                Spacer()

                // ── Waveform ─────────────────────────────────────────────
                WaveformAnimationView()

                Spacer()

                // ── Permission denied message ────────────────────────────
                if viewModel.permissionDenied {
                    Text("Permiso de micrófono o reconocimiento de voz denegado.\nActívalo en Configuración.")
                        .font(.subheadline)
                        .foregroundStyle(Color.red.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                } else {
                    // ── Transcription ────────────────────────────────────
                    Text(viewModel.transcribedText.isEmpty ? " " : "\(viewModel.transcribedText)")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .italic()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.transcribedText)
                }

                Spacer().frame(height: 32)

                // ── Result card ──────────────────────────────────────────
                if viewModel.hasResult {
                    resultCard
                        .padding(.horizontal, 24)
                }

                Spacer()

                // ── Stop button ──────────────────────────────────────────
                stopButton
                    .padding(.bottom, 60)
            }
        }
        .task {
            await viewModel.startListening()
        }
    }

    // MARK: - Result Card

    private var resultCard: some View {
        HStack(spacing: 0) {
            // CATEGORIA
            VStack(alignment: .leading, spacing: 6) {
                Text("CATEGORIA")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white.opacity(0.5))
                    .tracking(1)
                Text(viewModel.detectedCategory ?? "—")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(teal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 24)

            Divider()
                .frame(width: 1, height: 44)
                .background(Color.white.opacity(0.15))

            // MONTO
            VStack(alignment: .trailing, spacing: 6) {
                Text("MONTO")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white.opacity(0.5))
                    .tracking(1)
                Text(viewModel.detectedAmount.map { viewModel.formattedAmount($0) } ?? "—")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 24)
        }
        .padding(.vertical, 20)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Stop Button

    private var stopButton: some View {
        VStack(spacing: 8) {
            Button {
                viewModel.stopListening()
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.red.opacity(0.5), lineWidth: 2)
                        .frame(width: 72, height: 72)
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.red)
                        .frame(width: 26, height: 26)
                }
            }

            Text("STOP")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .tracking(2)
        }
    }
}

// MARK: - Preview
#Preview {
    VoiceInputView(
        viewModel: VoiceInputViewModel(onDismiss: {})
    )
}

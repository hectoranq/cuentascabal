import SwiftUI

struct ReceiptCaptureView: View {

    @StateObject var viewModel: ReceiptCaptureViewModel

    private let screenBg = Color(red: 0.239, green: 0.318, blue: 0.329)
    private let overlayDark = Color.black.opacity(0.45)

    var body: some View {
        ZStack {
            screenBg.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Top bar ──────────────────────────────────────────────
                topBar
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                Spacer().frame(height: 24)

                // ── Viewfinder ───────────────────────────────────────────
                viewfinder
                    .padding(.horizontal, 24)

                // ── Helper text ──────────────────────────────────────────
                Text("Align the edges of the receipt within the frame")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                Spacer()

                // ── Bottom controls ──────────────────────────────────────
                bottomControls
                    .padding(.bottom, 40)
                    .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            // Close
            Button { viewModel.dismiss() } label: {
                iconCircle(systemName: "xmark", size: 16, circleDiameter: 38, bg: overlayDark)
            }

            Spacer()

            // Auto-capture pill
            Button { viewModel.toggleAutoCapture() } label: {
                Text("Auto-Capture \(viewModel.autoCaptureOn ? "ON" : "OFF")")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(overlayDark)
                    .clipShape(Capsule())
            }

            Spacer()

            // Flash
            Button { viewModel.toggleFlash() } label: {
                iconCircle(
                    systemName: viewModel.flashOn ? "bolt.fill" : "bolt.slash.fill",
                    size: 16,
                    circleDiameter: 38,
                    bg: overlayDark
                )
            }
        }
    }

    // MARK: - Viewfinder

    private var viewfinder: some View {
        ZStack(alignment: .top) {
            // Frame background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.35, green: 0.43, blue: 0.44))
                .aspectRatio(0.68, contentMode: .fit)
                .overlay(
                    // Green top-edge highlight
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.green, lineWidth: 2)
                        .mask(
                            VStack(spacing: 0) {
                                Color.green.frame(height: 4)
                                Color.clear
                            }
                        )
                )

            // Mock receipt content
            VStack(alignment: .leading, spacing: 0) {
                // Date badge
                Text("Date: ")
                    .foregroundStyle(.white.opacity(0.9))
                + Text("20/03")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.green)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)
            .padding(.leading, 32)

            // Tax badge
            VStack(alignment: .trailing, spacing: 0) {
                (Text("Tax: ")
                    .foregroundStyle(.white.opacity(0.9))
                + Text("$21.00")
                    .fontWeight(.bold)
                    .foregroundStyle(.white))
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 130)
            .padding(.trailing, 32)

            // Total badge
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("TOTAL:")
                    .font(.subheadline)
                    .foregroundStyle(Color.black.opacity(0.6))
                Text("$150.00")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 240)
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Segmented mode pill
            modeSegment

            // Action row
            HStack {
                // Gallery thumbnail
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.system(size: 22))
                    )

                Spacer()

                // Shutter
                Button { /* capture */ } label: {
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.4), lineWidth: 4)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 66, height: 66)
                    }
                }

                Spacer()

                // Document button
                Button { /* open documents */ } label: {
                    iconCircle(systemName: "doc.text.fill", size: 20, circleDiameter: 56, bg: overlayDark)
                }
            }
        }
    }

    private var modeSegment: some View {
        HStack(spacing: 0) {
            ForEach([CaptureMode.single, .batch], id: \.self) { mode in
                Button {
                    viewModel.captureMode = mode
                } label: {
                    Text(mode == .single ? "Single" : "Batch Mode")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(viewModel.captureMode == mode ? .black : .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.captureMode == mode ? Color.white : Color.clear
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(overlayDark)
        .clipShape(Capsule())
    }

    // MARK: - Helper

    private func iconCircle(systemName: String, size: CGFloat, circleDiameter: CGFloat, bg: Color) -> some View {
        ZStack {
            Circle()
                .fill(bg)
                .frame(width: circleDiameter, height: circleDiameter)
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    ReceiptCaptureView(
        viewModel: ReceiptCaptureViewModel(onDismiss: {})
    )
}

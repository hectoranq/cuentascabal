import SwiftUI

struct WaveformAnimationView: View {

    private let barCount = 11
    private let teal = Color(red: 0, green: 0.788, blue: 0.647)   // #00C9A7
    private let white = Color.white

    @State private var heights: [CGFloat] = Array(repeating: 0.35, count: 11)

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(index == barCount / 2 ? white : teal)
                    .frame(width: 5, height: 80 * heights[index])
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.4...0.8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.07),
                        value: heights[index]
                    )
            }
        }
        .frame(height: 80)
        .onAppear {
            for i in 0..<barCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                    heights[i] = CGFloat.random(in: 0.3...1.0)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.075, green: 0.098, blue: 0.141).ignoresSafeArea()
        WaveformAnimationView()
    }
}

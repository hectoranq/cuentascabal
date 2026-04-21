import Foundation
import SwiftUI
internal import Combine
enum CaptureMode {
    case single, batch
}

@MainActor
final class ReceiptCaptureViewModel: ObservableObject {

    @Published var autoCaptureOn: Bool = true
    @Published var captureMode: CaptureMode = .single
    @Published var flashOn: Bool = false

    let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    func dismiss() {
        onDismiss()
    }

    func toggleFlash() {
        flashOn.toggle()
    }

    func toggleAutoCapture() {
        autoCaptureOn.toggle()
    }
}

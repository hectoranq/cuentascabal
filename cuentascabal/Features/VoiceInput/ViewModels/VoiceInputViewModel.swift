import Foundation
import SwiftUI
import Speech
import AVFoundation
internal import Combine
@MainActor
final class VoiceInputViewModel: ObservableObject {

    // MARK: - Published

    @Published var isListening: Bool = false
    @Published var transcribedText: String = ""
    @Published var detectedCategory: String? = nil
    @Published var detectedAmount: Double? = nil
    @Published var permissionDenied: Bool = false

    var hasResult: Bool { detectedCategory != nil && detectedAmount != nil }

    // MARK: - Private

    private let speechRecognizer: SFSpeechRecognizer? = {
        SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
        ?? SFSpeechRecognizer(locale: Locale(identifier: "es-ES"))
        ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    }()
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Init

    let onDismiss: () -> Void

    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    // MARK: - Public

    func startListening() async {
        // 1. Request speech recognition permission
        let speechStatus: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        guard speechStatus == .authorized else {
            permissionDenied = true
            return
        }

        // 2. Request microphone permission
        let micGranted: Bool = await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        guard micGranted else {
            permissionDenied = true
            return
        }

        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            return
        }

        do {
            try beginRecognition(using: recognizer)
        } catch {
            isListening = false
        }
    }

    func stopListening() {
        teardown()
        isListening = false
        onDismiss()
    }

    func formattedAmount(_ value: Double) -> String {
        String(format: "$%.2f", value)
    }

    // MARK: - Private helpers

    private func beginRecognition(using recognizer: SFSpeechRecognizer) throws {
        // Cancel any existing task
        teardown()

        // Configure audio session
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .default)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        // Create request
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request

        // Install audio tap
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        // Start recognition task
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            Task { @MainActor in
                if let result {
                    self.transcribedText = result.bestTranscription.formattedString
                }
                if error != nil || (result?.isFinal == true) {
                    self.teardown()
                    self.isListening = false
                }
            }
        }

        // Start engine
        audioEngine.prepare()
        try audioEngine.start()
        isListening = true
    }

    private func teardown() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

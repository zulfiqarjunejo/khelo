//
//  ChildSpeechAnnouncer.swift
//  khelo
//
//  Speaks a number word, pauses briefly, then speaks the matching object
//  word — e.g. "Five" ... "Apples" — using two queued AVSpeechUtterances.
//

import AVFoundation
import Combine

@MainActor
final class ChildSpeechAnnouncer: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()

    /// Speaks `number`, pauses, then speaks `word` (e.g. "Five" ... "Apples").
    func speakNumberAndWord(number: String, word: String) {
        synthesizer.stopSpeaking(at: .immediate)

        let numberUtterance = AVSpeechUtterance(string: "\(number)!")
        numberUtterance.rate = 0.34
        numberUtterance.pitchMultiplier = 1.35
        numberUtterance.postUtteranceDelay = 0.15

        let wordUtterance = AVSpeechUtterance(string: "\(word)!")
        wordUtterance.rate = 0.34
        wordUtterance.pitchMultiplier = 1.35

        synthesizer.speak(numberUtterance)
        synthesizer.speak(wordUtterance)
    }

    /// Speaks a short celebratory phrase after a correct answer.
    func speakPraise() {
        let praises = ["Yay!", "Great job!", "Well done!", "You did it!"]
        let utterance = AVSpeechUtterance(string: praises.randomElement() ?? "Yay!")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2

        synthesizer.stopSpeaking(at: .word)
        synthesizer.speak(utterance)
    }
}

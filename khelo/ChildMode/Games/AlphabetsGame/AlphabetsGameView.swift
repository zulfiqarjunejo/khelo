//
//  AlphabetsGameView.swift
//  khelo
//
//  Third Child Mode game: "Alphabets". Wherever the child touches the
//  screen, a random uppercase letter pops up at that spot with a matching
//  spoken letter to reinforce letter recognition — mirrors NumbersGameView.
//

import SwiftUI

private struct PoppedLetter: Identifiable {
    let id = UUID()
    let letter: String
    let position: CGPoint
    let color: Color
}

struct AlphabetsGameView: View {
    fileprivate static let lifetime: Double = 1.4

    private static let letters: [String] = (65...90).map { String(UnicodeScalar($0)!) }

    @State private var poppedLetters: [PoppedLetter] = []

    private let announcer = ChildSpeechAnnouncer()
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .teal]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if poppedLetters.isEmpty {
                Label("Touch anywhere to see a letter!", systemImage: "hand.tap.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            ForEach(poppedLetters) { letter in
                PoppedLetterView(letter: letter)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            SpatialTapGesture(count: 1)
                .onEnded { value in
                    handleTap(at: value.location)
                }
        )
        .navigationTitle("Alphabets")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleTap(at location: CGPoint) {
        let letter = Self.letters.randomElement() ?? "A"
        let popped = PoppedLetter(
            letter: letter,
            position: location,
            color: colors.randomElement() ?? .blue
        )

        poppedLetters.append(popped)

        announcer.speakWord(letter)

        Task {
            try? await Task.sleep(for: .seconds(Self.lifetime))
            poppedLetters.removeAll { $0.id == popped.id }
        }
    }
}

/// A single letter that pops in big and shrinks away to nothing.
private struct PoppedLetterView: View {
    let letter: PoppedLetter

    @State private var scale: CGFloat = 1.6
    @State private var opacity: Double = 1

    var body: some View {
        Text(letter.letter)
            .font(.system(size: 96, weight: .heavy, design: .rounded))
            .foregroundStyle(letter.color)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(letter.position)
            .onAppear {
                withAnimation(.easeIn(duration: AlphabetsGameView.lifetime)) {
                    scale = 0.2
                    opacity = 0
                }
            }
    }
}

#Preview {
    NavigationStack {
        AlphabetsGameView()
    }
}

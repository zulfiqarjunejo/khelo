//
//  NumbersGameView.swift
//  khelo
//
//  Second Child Mode game: "Numbers". Wherever the child touches the
//  screen, a random number pops up at that spot with a matching spoken
//  number to reinforce the digit and its name.
//

import SwiftUI

private struct PoppedNumber: Identifiable {
    let id = UUID()
    let value: Int
    let position: CGPoint
    let color: Color
}

struct NumbersGameView: View {
    fileprivate static let lifetime: Double = 1.4

    @State private var poppedNumbers: [PoppedNumber] = []

    private let announcer = ChildSpeechAnnouncer()
    private let range = 1...10
    private let colors: [Color] = Color.childFriendlyPalette

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if poppedNumbers.isEmpty {
                Label("Touch anywhere to see a number!", systemImage: "hand.tap.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            ForEach(poppedNumbers) { number in
                PoppedNumberView(number: number)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            SpatialTapGesture(count: 1)
                .onEnded { value in
                    handleTap(at: value.location)
                }
        )
        .navigationTitle("Numbers")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleTap(at location: CGPoint) {
        let value = Int.random(in: range)
        let popped = PoppedNumber(
            value: value,
            position: location,
            color: colors.randomElement() ?? .blue
        )

        poppedNumbers.append(popped)

        announcer.speakWord(NumberWordsCatalog.numberWords[value - 1])

        Task {
            try? await Task.sleep(for: .seconds(NumbersGameView.lifetime))
            poppedNumbers.removeAll { $0.id == popped.id }
        }
    }
}

/// A single number that pops in big and shrinks away to nothing.
private struct PoppedNumberView: View {
    let number: PoppedNumber

    @State private var scale: CGFloat = 1.6
    @State private var opacity: Double = 1

    var body: some View {
        Text("\(number.value)")
            .font(.system(size: 96, weight: .heavy, design: .rounded))
            .foregroundStyle(number.color)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(number.position)
            .onAppear {
                withAnimation(.easeIn(duration: NumbersGameView.lifetime)) {
                    scale = 0.2
                    opacity = 0
                }
            }
    }
}

#Preview {
    NavigationStack {
        NumbersGameView()
    }
}

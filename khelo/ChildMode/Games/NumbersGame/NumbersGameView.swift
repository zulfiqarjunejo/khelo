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
    @State private var poppedNumbers: [PoppedNumber] = []

    private let announcer = ChildSpeechAnnouncer()
    private let range = 1...10
    private let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .teal]

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
                Text("\(number.value)")
                    .font(.system(size: 96, weight: .heavy, design: .rounded))
                    .foregroundStyle(number.color)
                    .position(number.position)
                    .transition(.scale.combined(with: .opacity))
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

        withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
            poppedNumbers.append(popped)
        }

        announcer.speakNumber(NumberWordsCatalog.numberWords[value - 1])

        Task {
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.easeOut(duration: 0.3)) {
                poppedNumbers.removeAll { $0.id == popped.id }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NumbersGameView()
    }
}

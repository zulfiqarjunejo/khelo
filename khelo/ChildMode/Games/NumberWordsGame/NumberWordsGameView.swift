//
//  NumberWordsGameView.swift
//  khelo
//
//  First real Child Mode game: "Names and Numbers". Shows a group of
//  objects, speaks "five... apples", and the child taps anywhere on
//  screen to move on to the next round.
//

import SwiftUI

struct NumberWordsGameView: View {
    @StateObject private var viewModel = NumberWordsGameViewModel()

    private let objectColumns = [GridItem(.adaptive(minimum: 70), spacing: 12)]

    var body: some View {
        VStack(spacing: 28) {
            Text("Round \(viewModel.roundsCompleted + 1)")
                .font(.headline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: objectColumns, spacing: 12) {
                ForEach(0..<viewModel.round.count, id: \.self) { _ in
                    Text(viewModel.round.object.emoji)
                        .font(.system(size: 48))
                }
            }
            .padding()
            .frame(maxWidth: 340)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24))

            Button {
                viewModel.speakCurrentRound()
            } label: {
                Label("Listen Again", systemImage: "speaker.wave.2.fill")
                    .font(.title3.bold())
            }
            .buttonStyle(.borderedProminent)

            Spacer(minLength: 0)

            Label("Tap anywhere to continue", systemImage: "hand.tap.fill")
                .font(.title3.bold())
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.advanceToNextRound()
        }
        .navigationTitle("Names and Numbers")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.speakCurrentRound()
        }
    }
}

#Preview {
    NavigationStack {
        NumberWordsGameView()
    }
}

//
//  ChildGamesHomeView.swift
//  khelo
//
//  Home screen shown while Child Mode is locked: a grid of games/activities.
//  Owns its own NavigationStack so games can push in/out without disturbing
//  the parent-facing NavigationStack in ContentView.
//

import SwiftUI

struct ChildGamesHomeView: View {
    private let columns = [GridItem(.adaptive(minimum: 140), spacing: 16)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ChildGameCatalog.games) { game in
                        NavigationLink(value: game) {
                            ChildGameCardView(game: game)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Let's Play!")
            .navigationDestination(for: ChildGame.self) { game in
                destinationView(for: game)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for game: ChildGame) -> some View {
        switch game.kind {
        case .numberWords:
            NumberWordsGameView()
        case .numbersPop:
            NumbersGameView()
        case .alphabetsPop:
            AlphabetsGameView()
        case .placeholder:
            PlaceholderGameView(game: game)
        }
    }
}

#Preview {
    ChildGamesHomeView()
}

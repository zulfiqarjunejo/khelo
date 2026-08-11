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

    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var paywallGame: ChildGame?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ChildGameCatalog.games) { game in
                        let isLocked = game.isPremium && !purchaseManager.isPremiumUnlocked

                        if isLocked {
                            Button {
                                paywallGame = game
                            } label: {
                                ChildGameCardView(game: game, isLocked: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            NavigationLink(value: game) {
                                ChildGameCardView(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Let's Play!")
            .navigationDestination(for: ChildGame.self) { game in
                destinationView(for: game)
            }
        }
        // Keep colors bold and consistent for children regardless of the
        // parent device's Dark Mode setting.
        .preferredColorScheme(.light)
        .sheet(item: $paywallGame) { _ in
            PaywallView(purchaseManager: purchaseManager)
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
        case .shapeSorter:
            ShapeSorterGameView()
        case .balloonPop:
            BalloonsGameView()
        case .placeholder:
            PlaceholderGameView(game: game)
        }
    }
}

#Preview {
    ChildGamesHomeView()
}

//
//  PlaceholderGameView.swift
//  khelo
//
//  Generic "coming soon" screen used by every game in the catalog that
//  hasn't been built yet. Replace with a real game view and switch the
//  catalog entry's `kind` when ready.
//

import SwiftUI

struct PlaceholderGameView: View {
    let game: ChildGame

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: game.symbolName)
                .font(.system(size: 72))
                .foregroundStyle(game.tint)

            Text(game.title)
                .font(.largeTitle.bold())

            Text("This game is coming soon. Check back later!")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .padding()
        .navigationTitle(game.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

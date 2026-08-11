//
//  ChildGameCardView.swift
//  khelo
//
//  A single tappable tile on the Child Mode games grid.
//

import SwiftUI

struct ChildGameCardView: View {
    let game: ChildGame

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: game.symbolName)
                .font(.system(size: 34))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(game.tint.gradient, in: Circle())

            Text(game.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            Text(game.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

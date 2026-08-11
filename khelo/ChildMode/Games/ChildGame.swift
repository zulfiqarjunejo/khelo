//
//  ChildGame.swift
//  khelo
//
//  Model + catalog for the games/activities shown on the Child Mode home
//  screen. Add a new entry to `ChildGameCatalog.games` and a case to
//  `ChildGamesHomeView.destinationView(for:)` to wire up a new game.
//

import SwiftUI

enum ChildGameKind: Hashable {
    case numberWords
    case numbersPop
    case placeholder
}

struct ChildGame: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let symbolName: String
    let tint: Color
    let kind: ChildGameKind
}

enum ChildGameCatalog {
    /// First real game (Duolingo-style numbers & words) plus placeholders
    /// for future activities.
    static let games: [ChildGame] = [
        ChildGame(
            title: "Names and Numbers",
            subtitle: "Listen & discover",
            symbolName: "textformat.123",
            tint: .orange,
            kind: .numberWords
        ),
        ChildGame(
            title: "Numbers",
            subtitle: "Tap & pop",
            symbolName: "hand.tap.fill",
            tint: .teal,
            kind: .numbersPop
        ),
        ChildGame(
            title: "Shape Sorter",
            subtitle: "Coming soon",
            symbolName: "square.on.circle",
            tint: .blue,
            kind: .placeholder
        ),
        ChildGame(
            title: "Color Match",
            subtitle: "Coming soon",
            symbolName: "paintpalette.fill",
            tint: .pink,
            kind: .placeholder
        ),
        ChildGame(
            title: "Animal Sounds",
            subtitle: "Coming soon",
            symbolName: "pawprint.fill",
            tint: .brown,
            kind: .placeholder
        ),
        ChildGame(
            title: "Memory Match",
            subtitle: "Coming soon",
            symbolName: "square.grid.2x2.fill",
            tint: .purple,
            kind: .placeholder
        ),
        ChildGame(
            title: "Puzzle Pieces",
            subtitle: "Coming soon",
            symbolName: "puzzlepiece.fill",
            tint: .green,
            kind: .placeholder
        ),
        ChildGame(
            title: "Story Time",
            subtitle: "Coming soon",
            symbolName: "book.fill",
            tint: .indigo,
            kind: .placeholder
        ),
    ]
}

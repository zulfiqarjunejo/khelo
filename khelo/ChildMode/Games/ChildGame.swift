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
    case alphabetsPop
    case shapeSorter
    case balloonPop
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
    /// Real, playable games. Placeholder ideas for future games are kept
    /// commented out below — uncomment (and set kind: .placeholder) once
    /// work on one actually starts.
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
            title: "Alphabets",
            subtitle: "Tap & pop",
            symbolName: "character",
            tint: .mint,
            kind: .alphabetsPop
        ),
        ChildGame(
            title: "Shape Sorter",
            subtitle: "Drag & match",
            symbolName: "square.on.circle",
            tint: .blue,
            kind: .shapeSorter
        ),
        ChildGame(
            title: "Balloons",
            subtitle: "Tap & pop",
            symbolName: "balloon.2.fill",
            tint: .red,
            kind: .balloonPop
        ),
        // Not built yet — uncomment when ready to work on it.
        // ChildGame(
        //     title: "Color Match",
        //     subtitle: "Coming soon",
        //     symbolName: "paintpalette.fill",
        //     tint: .pink,
        //     kind: .placeholder
        // ),
        // ChildGame(
        //     title: "Animal Sounds",
        //     subtitle: "Coming soon",
        //     symbolName: "pawprint.fill",
        //     tint: .brown,
        //     kind: .placeholder
        // ),
        // ChildGame(
        //     title: "Memory Match",
        //     subtitle: "Coming soon",
        //     symbolName: "square.grid.2x2.fill",
        //     tint: .purple,
        //     kind: .placeholder
        // ),
        // ChildGame(
        //     title: "Puzzle Pieces",
        //     subtitle: "Coming soon",
        //     symbolName: "puzzlepiece.fill",
        //     tint: .green,
        //     kind: .placeholder
        // ),
        // ChildGame(
        //     title: "Story Time",
        //     subtitle: "Coming soon",
        //     symbolName: "book.fill",
        //     tint: .indigo,
        //     kind: .placeholder
        // ),
    ]
}

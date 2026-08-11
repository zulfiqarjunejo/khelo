//
//  ChildFriendlyColors.swift
//  khelo
//
//  A shared, curated color palette used across the tap/pop games
//  (Numbers, Alphabets, Balloons, Shape Sorter). Toddlers respond best to
//  bold, highly saturated primary/secondary hues with strong contrast
//  against a white background — plain SwiftUI system colors like
//  `.yellow`, `.mint`, and `.teal` are tuned for adult UI chrome and can
//  look pale/washed-out (and they also shift with Dark Mode, which would
//  make the games look dim and less inviting for a child). These are
//  fixed custom RGB values so they always render bold, regardless of
//  system appearance.
//
import SwiftUI

extension Color {
    /// Bold, easily-distinguishable colors for young children.
    static let childFriendlyPalette: [Color] = [
        Color(red: 0.92, green: 0.20, blue: 0.20), // red
        Color(red: 1.00, green: 0.55, blue: 0.00), // orange
        Color(red: 1.00, green: 0.78, blue: 0.00), // golden yellow
        Color(red: 0.20, green: 0.70, blue: 0.25), // green
        Color(red: 0.00, green: 0.55, blue: 0.95), // sky blue
        Color(red: 0.55, green: 0.30, blue: 0.90), // purple
        Color(red: 0.95, green: 0.35, blue: 0.60), // pink
        Color(red: 0.00, green: 0.70, blue: 0.65), // teal
    ]
}

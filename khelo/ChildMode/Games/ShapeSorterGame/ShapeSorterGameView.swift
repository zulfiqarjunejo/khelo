//
//  ShapeSorterGameView.swift
//  khelo
//
//  Fourth Child Mode game: "Shape Sorter". A row of empty shape outlines
//  sits at the top; the matching filled shapes sit at the bottom. The
//  child drags each piece onto its matching outline to complete the set,
//  then a new round begins.
//

import SwiftUI
import Combine

enum ShapeKind: CaseIterable, Hashable {
    case circle, square, triangle, star, heart, hexagon

    fileprivate var name: String {
        switch self {
        case .circle: return "circle"
        case .square: return "square"
        case .triangle: return "triangle"
        case .star: return "star"
        case .heart: return "heart"
        case .hexagon: return "hexagon"
        }
    }

    fileprivate var filledSymbol: String { "\(name).fill" }
    fileprivate var outlineSymbol: String { name }

    fileprivate var color: Color {
        let palette = Color.childFriendlyPalette
        switch self {
        case .circle: return palette[0] // red
        case .square: return palette[4] // sky blue
        case .triangle: return palette[3] // green
        case .star: return palette[2] // golden yellow
        case .heart: return palette[6] // pink
        case .hexagon: return palette[5] // purple
        }
    }
}

@MainActor
final class ShapeSorterGameViewModel: ObservableObject {
    @Published private(set) var shapes: [ShapeKind]
    @Published private(set) var pieceOrder: [ShapeKind]
    @Published private(set) var matched: Set<ShapeKind> = []

    let announcer = ChildSpeechAnnouncer()

    private let shapeCount: Int

    init(shapeCount: Int = 3) {
        self.shapeCount = shapeCount
        let chosen = Array(ShapeKind.allCases.shuffled().prefix(shapeCount))
        self.shapes = chosen
        self.pieceOrder = chosen.shuffled()
    }

    var isRoundComplete: Bool {
        matched.count == shapes.count
    }

    func markMatched(_ shape: ShapeKind) {
        guard !matched.contains(shape) else { return }
        matched.insert(shape)
        announcer.speakWord(shape.name)
    }

    func startNewRound() {
        let chosen = Array(ShapeKind.allCases.shuffled().prefix(shapeCount))
        shapes = chosen
        pieceOrder = chosen.shuffled()
        matched = []
    }
}

private struct SlotFramesKey: PreferenceKey {
    static var defaultValue: [ShapeKind: CGRect] = [:]

    static func reduce(value: inout [ShapeKind: CGRect], nextValue: () -> [ShapeKind: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct ShapeSorterGameView: View {
    @StateObject private var viewModel = ShapeSorterGameViewModel()
    @State private var slotFrames: [ShapeKind: CGRect] = [:]

    var body: some View {
        VStack(spacing: 40) {
            Text("Match the shapes!")
                .font(.title2.bold())
                .foregroundStyle(.secondary)

            HStack(spacing: 20) {
                ForEach(viewModel.shapes, id: \.self) { shape in
                    ShapeSlotView(shape: shape, isMatched: viewModel.matched.contains(shape))
                }
            }

            Spacer(minLength: 0)

            HStack(spacing: 20) {
                ForEach(viewModel.pieceOrder.filter { !viewModel.matched.contains($0) }, id: \.self) { shape in
                    ShapePieceView(shape: shape) { location in
                        handleDrop(of: shape, at: location)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(minHeight: 100)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.matched)
        }
        .padding()
        .padding(.bottom, 40)
        .onPreferenceChange(SlotFramesKey.self) { slotFrames = $0 }
        .navigationTitle("Shape Sorter")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.matched) { _, _ in
            guard viewModel.isRoundComplete else { return }
            Task {
                try? await Task.sleep(for: .seconds(1.2))
                viewModel.startNewRound()
            }
        }
    }

    private func handleDrop(of shape: ShapeKind, at location: CGPoint) {
        guard let slotFrame = slotFrames[shape],
              slotFrame.insetBy(dx: -24, dy: -24).contains(location) else {
            return
        }
        viewModel.markMatched(shape)
    }
}

/// An empty outline that a matching piece can be dropped onto. Fills in
/// with color once matched.
private struct ShapeSlotView: View {
    let shape: ShapeKind
    let isMatched: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
            Image(systemName: isMatched ? shape.filledSymbol : shape.outlineSymbol)
                .font(.system(size: 44))
                .foregroundStyle(isMatched ? shape.color : Color.secondary)
        }
        .frame(width: 84, height: 84)
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SlotFramesKey.self, value: [shape: geo.frame(in: .global)])
            }
        )
    }
}

/// A draggable filled shape the child drags up onto its matching slot.
private struct ShapePieceView: View {
    let shape: ShapeKind
    let onDropped: (CGPoint) -> Void

    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging = false

    var body: some View {
        Image(systemName: shape.filledSymbol)
            .font(.system(size: 44))
            .foregroundStyle(shape.color)
            .frame(width: 84, height: 84)
            .background(
                Circle()
                    .fill(Color(.systemBackground))
                    .shadow(radius: isDragging ? 6 : 2)
            )
            .scaleEffect(isDragging ? 1.15 : 1.0)
            .offset(dragOffset)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .updating($isDragging) { _, state, _ in state = true }
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        onDropped(value.location)
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            dragOffset = .zero
                        }
                    }
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
    }
}

#Preview {
    NavigationStack {
        ShapeSorterGameView()
    }
}

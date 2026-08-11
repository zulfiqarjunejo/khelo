//
//  BalloonsGameView.swift
//  khelo
//
//  Fifth Child Mode game: "Balloons". Wherever the child touches the
//  screen, a colorful balloon appears with a pop sound, then shrinks away
//  to nothing over a few seconds — a pure tap-and-pop sensory game, no
//  numbers/letters/speech involved.
//

import SwiftUI
import AudioToolbox

private struct PoppedBalloon: Identifiable {
    let id = UUID()
    let position: CGPoint
    let color: Color
}

/// Plays a short pop/click sound using an iOS system sound so no bundled
/// audio asset is needed.
private struct BalloonPopSoundPlayer {
    private let popSoundID: SystemSoundID = 1104

    func playPop() {
        AudioServicesPlaySystemSound(popSoundID)
    }
}

struct BalloonsGameView: View {
    fileprivate static let lifetime: Double = 3.0

    @State private var balloons: [PoppedBalloon] = []

    private let soundPlayer = BalloonPopSoundPlayer()
    private let colors: [Color] = Color.childFriendlyPalette

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            if balloons.isEmpty {
                Label("Touch anywhere to pop a balloon!", systemImage: "hand.tap.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            ForEach(balloons) { balloon in
                PoppedBalloonView(balloon: balloon)
            }
        }
        .contentShape(Rectangle())
        .gesture(
            SpatialTapGesture(count: 1)
                .onEnded { value in
                    handleTap(at: value.location)
                }
        )
        .navigationTitle("Balloons")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleTap(at location: CGPoint) {
        let balloon = PoppedBalloon(
            position: location,
            color: colors.randomElement() ?? .red
        )
        balloons.append(balloon)

        soundPlayer.playPop()

        Task {
            try? await Task.sleep(for: .seconds(Self.lifetime))
            balloons.removeAll { $0.id == balloon.id }
        }
    }
}

/// A single balloon that pops in big and shrinks away to nothing.
private struct PoppedBalloonView: View {
    let balloon: PoppedBalloon

    @State private var scale: CGFloat = 1.6
    @State private var opacity: Double = 1

    var body: some View {
        Image(systemName: "balloon.fill")
            .font(.system(size: 90))
            .foregroundStyle(balloon.color)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(balloon.position)
            .onAppear {
                withAnimation(.easeIn(duration: BalloonsGameView.lifetime)) {
                    scale = 0.15
                    opacity = 0
                }
            }
    }
}

#Preview {
    NavigationStack {
        BalloonsGameView()
    }
}

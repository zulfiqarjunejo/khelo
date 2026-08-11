//
//  ChildLockOverlayView.swift
//  khelo
//
//  Full-screen overlay shown while Child Mode is requesting, locked,
//  or failed to lock. Exiting is handled entirely by iOS's own Guided
//  Access gesture (triple-click + passcode) — this view just reflects
//  status and reminds the parent how to exit.
//

import SwiftUI

struct ChildLockOverlayView: View {
    @ObservedObject var manager: ChildModeManager
    let onDismissFailure: () -> Void

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            VStack(spacing: 24) {
                switch manager.status {
                case .requesting:
                    ProgressView()
                        .scaleEffect(1.4)
                    Text("Activating Single App Mode…")
                        .foregroundStyle(.primary)
                        .font(.headline)

                case .locked:
                    ChildGamesHomeView()
                        .safeAreaInset(edge: .bottom) {
                            Text("Parent: triple-click the side (or Home) button and enter your Guided Access passcode to exit.")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                        }

                case .failed(let message):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.orange)
                    Text("Couldn't lock the device")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Button("OK") {
                        onDismissFailure()
                    }
                    .buttonStyle(.borderedProminent)

                case .inactive:
                    EmptyView()
                }
            }
        }
        .onChange(of: manager.status) { _, newStatus in
            UIApplication.shared.isIdleTimerDisabled = (newStatus == .locked)
        }
    }

    private var backgroundColor: Color {
        switch manager.status {
        case .failed: return Color(.systemBackground).opacity(0.98)
        default: return Color(.systemBackground)
        }
    }
}

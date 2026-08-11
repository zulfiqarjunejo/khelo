//
//  ChildModeManager.swift
//  khelo
//
//  Manages Child Mode: requests iOS Single App Mode (Guided Access) and
//  tracks/verifies its activation status. Exiting Guided Access is left
//  entirely to iOS's own gesture (triple-click + Guided Access passcode) —
//  we don't build a parallel exit mechanism, just reflect the true state.
//

import UIKit
import Combine

/// Current state of Child Mode / Single App Mode lock.
enum ChildLockStatus: Equatable {
    /// Child Mode is off, device is unrestricted.
    case inactive
    /// Waiting on iOS to respond to the Single App Mode request.
    case requesting
    /// iOS confirmed Single App Mode is active.
    case locked
    /// iOS refused (or we couldn't confirm) Single App Mode activation.
    case failed(String)
}

@MainActor
final class ChildModeManager: ObservableObject {

    @Published private(set) var status: ChildLockStatus = .inactive

    private var notificationObserver: NSObjectProtocol?

    init() {
        // Keep our published state honest if Guided Access is toggled
        // outside our own request (e.g. child triple-clicks to exit,
        // or a parent used the manual Guided Access controls).
        notificationObserver = NotificationCenter.default.addObserver(
            forName: UIAccessibility.guidedAccessStatusDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.syncStatusWithSystem()
        }
    }

    deinit {
        if let notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }

    var isSystemGuidedAccessActive: Bool {
        UIAccessibility.isGuidedAccessEnabled
    }

    /// US-01/US-02: Kick off Child Mode by asking iOS to enter Single App Mode.
    func startChildMode() {
        guard status != .requesting else { return }

        if UIAccessibility.isGuidedAccessEnabled {
            status = .locked
            return
        }

        status = .requesting

        UIAccessibility.requestGuidedAccessSession(enabled: true) { [weak self] success in
            DispatchQueue.main.async {
                self?.handleActivationResponse(success: success)
            }
        }
    }

    /// US-03: Confirm activation actually took effect before handing off the device.
    private func handleActivationResponse(success: Bool) {
        if success && UIAccessibility.isGuidedAccessEnabled {
            status = .locked
        } else {
            status = .failed(Self.activationFailureMessage)
        }
    }

    private func syncStatusWithSystem() {
        switch status {
        case .locked, .requesting:
            status = UIAccessibility.isGuidedAccessEnabled ? .locked : .inactive
        case .inactive, .failed:
            // Only promote to locked; don't downgrade an explicit failed/inactive
            // state from a stray notification.
            if UIAccessibility.isGuidedAccessEnabled {
                status = .locked
            }
        }
    }

    /// Dismisses a `.failed` state back to `.inactive` so the parent can retry
    /// or fall back to manual Guided Access. Does not change any system state.
    func acknowledgeFailure() {
        if case .failed = status {
            status = .inactive
        }
    }

    /// US-06: Human-readable explanation + manual fallback when auto-lock fails.
    static let activationFailureMessage = """
    iOS refused to start Single App Mode automatically. This device is not \
    supervised with an MDM profile that authorizes khelo for Autonomous \
    Single App Mode, so the automatic lock cannot engage.

    Do not hand the device to your child yet. To lock it manually instead, \
    open Settings > Accessibility > Guided Access, enable it, then triple-click \
    the side (or Home) button inside khelo to start a Guided Access session.
    """
}

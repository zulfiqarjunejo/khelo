//
//  OnboardingManager.swift
//  khelo
//
//  Tracks whether the user has completed the first-launch onboarding
//  wizard, persisted across launches. Extend with more flags here if
//  future onboarding flows need independent completion tracking.
//

import Foundation
import Combine

@MainActor
final class OnboardingManager: ObservableObject {
    private static let hasCompletedOnboardingKey = "hasCompletedOnboarding"

    private let defaults: UserDefaults

    @Published private(set) var hasCompletedOnboarding: Bool

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.hasCompletedOnboarding = defaults.bool(forKey: Self.hasCompletedOnboardingKey)
    }

    func complete() {
        hasCompletedOnboarding = true
        defaults.set(true, forKey: Self.hasCompletedOnboardingKey)
    }

    /// Lets a parent replay the wizard later (e.g. "Setup Guide" button).
    func reset() {
        hasCompletedOnboarding = false
        defaults.set(false, forKey: Self.hasCompletedOnboardingKey)
    }
}

//
//  GuidedAccessOnboardingSteps.swift
//  khelo
//
//  Concrete step content for the "get ready for your child" wizard.
//  This is the only file that needs to change to add/edit/reorder
//  Guided Access onboarding steps.
//

import SwiftUI

enum GuidedAccessOnboardingSteps {
    static func makeSteps() -> [OnboardingStep] {
        [
            OnboardingStep(
                id: "welcome",
                title: "Set Up Child Mode",
                primaryButtonTitle: "Get Started"
            ) {
                OnboardingStepCard(
                    icon: "checkmark.shield.fill",
                    heading: "Let's get it ready for your child",
                    detail: "Guided Access locks the device to khelo. It takes about a minute to set up, and only needs to be done once per device."
                )
            },
            OnboardingStep(id: "enable", title: "Step 1 of 4") {
                OnboardingStepCard(
                    icon: "gearshape.fill",
                    heading: "Turn on Guided Access",
                    detail: "Leave khelo, open the Settings app from your Home Screen, then go to Accessibility > Guided Access and switch it on."
                )
            },
            OnboardingStep(id: "passcode", title: "Step 2 of 4") {
                OnboardingStepCard(
                    icon: "lock.fill",
                    heading: "Set a Guided Access passcode",
                    detail: "Choose a passcode different from your device passcode, so only you can end the session."
                )
            },
            OnboardingStep(id: "return", title: "Step 3 of 4") {
                OnboardingStepCard(
                    icon: "arrow.uturn.backward.circle.fill",
                    heading: "Come back to khelo",
                    detail: "Return to this app before starting the session."
                )
            },
            OnboardingStep(id: "start", title: "Step 4 of 4", primaryButtonTitle: "Done") {
                OnboardingStepCard(
                    icon: "hand.tap.fill",
                    heading: "Triple-click the side button",
                    detail: "While inside khelo, triple-click the side button (or Home button on older iPhones), then tap Start in the top-right corner."
                )
            }
        ]
    }
}

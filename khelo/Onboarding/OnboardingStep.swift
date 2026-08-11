//
//  OnboardingStep.swift
//  khelo
//
//  Generic model for a single page in an onboarding wizard. Content is
//  type-erased so heterogeneous steps (different views, different future
//  features) can live in one `[OnboardingStep]` array.
//

import SwiftUI

struct OnboardingStep: Identifiable {
    let id: String
    let title: String
    let content: AnyView

    /// Optional override for the primary ("Next"/"Done") button label on this step.
    let primaryButtonTitle: String?

    init<Content: View>(
        id: String,
        title: String,
        primaryButtonTitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.title = title
        self.primaryButtonTitle = primaryButtonTitle
        self.content = AnyView(content())
    }
}

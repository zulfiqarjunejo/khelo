//
//  OnboardingStepCard.swift
//  khelo
//
//  Shared visual layout for a simple icon + title + detail onboarding
//  step, with an optional action button. Reused across steps so new
//  onboarding content stays visually consistent.
//

import SwiftUI

struct OnboardingStepCard<Action: View>: View {
    let icon: String
    let heading: String
    let detail: String
    @ViewBuilder var action: () -> Action

    init(
        icon: String,
        heading: String,
        detail: String,
        @ViewBuilder action: @escaping () -> Action = { EmptyView() }
    ) {
        self.icon = icon
        self.heading = heading
        self.detail = detail
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(.tint)

            Text(heading)
                .font(.title3.bold())

            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            action()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//
//  OnboardingWizardView.swift
//  khelo
//
//  Generic, reusable step-by-step wizard container. Feed it any
//  `[OnboardingStep]` array; it handles progress, back/next/skip
//  navigation and completion. Add new flows by building a new steps
//  array elsewhere — this view never needs to change.
//

import SwiftUI

struct OnboardingWizardView: View {
    let steps: [OnboardingStep]
    /// Called when the user finishes the last step or taps Skip.
    let onFinish: () -> Void

    @State private var currentIndex = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(currentIndex + 1), total: Double(steps.count))
                    .padding(.horizontal)
                    .padding(.top, 8)

                ScrollView {
                    steps[currentIndex].content
                        .padding()
                }

                Divider()

                HStack {
                    if currentIndex > 0 {
                        Button("Back") {
                            withAnimation { currentIndex -= 1 }
                        }
                    }

                    Spacer()

                    Button(primaryButtonTitle) {
                        advance()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle(steps[currentIndex].title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") { onFinish() }
                }
            }
        }
    }

    private var isLastStep: Bool {
        currentIndex == steps.count - 1
    }

    private var primaryButtonTitle: String {
        steps[currentIndex].primaryButtonTitle ?? (isLastStep ? "Done" : "Next")
    }

    private func advance() {
        if isLastStep {
            onFinish()
        } else {
            withAnimation { currentIndex += 1 }
        }
    }
}

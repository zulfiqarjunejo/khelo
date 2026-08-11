import SwiftUI

struct ContentView: View {
    @State private var isShowingSetupGuide = false
    @StateObject private var childModeManager = ChildModeManager()
    @StateObject private var onboardingManager = OnboardingManager()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    Image(systemName: "figure.and.child.holdinghands")
                        .font(.system(size: 48))
                        .foregroundStyle(.tint)

                    Text("Welcome, Parent!")
                        .font(.largeTitle.bold())

                    Text("Ready to hand the device over? Triple-click the side button (or Home button) now to start Guided Access and lock this device to khelo for your child.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding()

                if childModeManager.status != .inactive {
                    ChildLockOverlayView(manager: childModeManager) {
                        childModeManager.acknowledgeFailure()
                    }
                    .transition(.opacity)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSetupGuide = true
                    } label: {
                        Image(systemName: "wand.and.stars")
                    }
                }
            }
        }
        .onAppear {
            if !onboardingManager.hasCompletedOnboarding {
                isShowingSetupGuide = true
            }
        }
        .fullScreenCover(isPresented: $isShowingSetupGuide) {
            OnboardingWizardView(steps: GuidedAccessOnboardingSteps.makeSteps()) {
                onboardingManager.complete()
                isShowingSetupGuide = false
            }
        }
        .animation(.default, value: childModeManager.status)
    }
}

#Preview {
    ContentView()
}

//
//  PaywallView.swift
//  khelo
//
//  Sheet shown when a parent taps a locked (premium) game from the Child
//  Mode home screen. Offers the one-time "Premium Games" unlock.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.orange.gradient)
                    .padding(.top, 24)

                VStack(spacing: 8) {
                    Text("Unlock Premium Games")
                        .font(.title2.bold())
                    Text("Get Names and Numbers, Shape Sorter, and Balloons — plus every premium game we add in the future.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        Task { await purchaseManager.purchase() }
                    } label: {
                        HStack {
                            if purchaseManager.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(purchaseButtonTitle)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(purchaseManager.isLoading || purchaseManager.product == nil)

                    Button("Restore Purchases") {
                        Task { await purchaseManager.restorePurchases() }
                    }
                    .disabled(purchaseManager.isLoading)
                }
                .padding(.bottom, 8)
            }
            .padding()
            .navigationTitle("Premium Games")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .alert(
                "Store",
                isPresented: Binding(
                    get: { purchaseManager.errorMessage != nil },
                    set: { if !$0 { purchaseManager.errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(purchaseManager.errorMessage ?? "")
            }
            .onChange(of: purchaseManager.isPremiumUnlocked) { _, isUnlocked in
                if isUnlocked { dismiss() }
            }
            .task {
                // The shared PurchaseManager only loads the product once,
                // at app launch. If that attempt happened before the
                // StoreKit configuration was fully wired up (or failed
                // for any transient reason), retry every time the
                // paywall is shown instead of leaving it stuck on "Unlock"
                // with no price for the rest of the app session.
                if purchaseManager.product == nil {
                    await purchaseManager.loadProduct()
                }
            }
        }
    }

    private var purchaseButtonTitle: String {
        if let price = purchaseManager.product?.displayPrice {
            return "Unlock for \(price)"
        }
        return "Unlock"
    }
}

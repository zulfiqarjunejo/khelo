//
//  PurchaseManager.swift
//  khelo
//
//  Manages the single "Premium Games" non-consumable in-app purchase
//  that unlocks Child Mode's paid games (Names and Numbers, Shape
//  Sorter, Balloons). "Numbers" and "Alphabets" always stay free.
//
//  Uses StoreKit 2. For local testing in Xcode/Simulator without an App
//  Store Connect product, select khelo/Configuration.storekit as the
//  scheme's StoreKit Configuration (Edit Scheme > Run > Options).
//

import StoreKit
import Combine

@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    /// Non-consumable product that unlocks every premium Child Mode game.
    static let premiumGamesProductID = "com.zulfiqarjunejo.khelo.premiumgames"

    @Published private(set) var isPremiumUnlocked = false
    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private var transactionListenerTask: Task<Void, Never>?

    private init() {
        transactionListenerTask = listenForTransactionUpdates()
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
    }

    deinit {
        transactionListenerTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.premiumGamesProductID])
            product = products.first
            if products.isEmpty {
                errorMessage = "No StoreKit product found for ID \"\(Self.premiumGamesProductID)\". Check that Configuration.storekit's Product ID matches exactly, and that the scheme's Run > Options > StoreKit Configuration is set to Configuration.storekit."
            }
        } catch {
            errorMessage = "Couldn't load store info: \(error.localizedDescription)"
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.premiumGamesProductID {
                isPremiumUnlocked = true
                return
            }
        }
        isPremiumUnlocked = false
    }

    func purchase() async {
        guard let product else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    isPremiumUnlocked = true
                    await transaction.finish()
                case .unverified(_, let verificationError):
                    errorMessage = "Purchase could not be verified: \(verificationError.localizedDescription)"
                }
            case .userCancelled:
                break
            case .pending:
                errorMessage = "Purchase is pending approval (e.g. Ask to Buy) and hasn't completed yet."
            @unknown default:
                break
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await refreshEntitlements()
            if !isPremiumUnlocked {
                errorMessage = "No previous purchase was found."
            }
        } catch {
            errorMessage = "Restore failed. Please try again."
        }
    }

    private func listenForTransactionUpdates() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result,
                      transaction.productID == Self.premiumGamesProductID else { continue }
                await self?.markUnlocked()
                await transaction.finish()
            }
        }
    }

    private func markUnlocked() {
        isPremiumUnlocked = true
    }
}

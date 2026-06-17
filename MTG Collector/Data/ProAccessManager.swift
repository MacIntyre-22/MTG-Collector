//
//  ProAccessManager.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      StoreKit 2 entitlement manager for the one-time "Card Hoard Pro" unlock. Single source of
//      truth for `isPro` — checks current entitlements, listens for transaction updates, and
//      handles purchase + restore. Inject at the app root; gate Pro features through `isPro`.
//      A `.storekit` config (Products.storekit) lets this be tested without App Store Connect.
//  External Types:
//      (StoreKit)
//

// MARK: Imports

import Foundation
import StoreKit

// MARK: Manager

@MainActor
@Observable
final class ProAccessManager {

    /// Must match the non-consumable product ID registered in App Store Connect.
    static let productID = "net.benmacintyre.cardhoard.pro"

    private(set) var product: Product?
    /// True once a verified StoreKit entitlement is found.
    private(set) var entitled = false
    private(set) var purchaseInProgress = false
    var lastError: String?

    private var updatesTask: Task<Void, Never>?

#if DEBUG
    /// Developer override (DEBUG only) so the app is fully usable before IAP/CloudKit are live.
    /// Compiled out of release builds — Apple never sees it.
    var devUnlock = true {
        didSet { UserDefaults.standard.set(devUnlock, forKey: "devUnlockPro") }
    }
    /// Pro is unlocked by a real purchase OR the developer override.
    var isPro: Bool { entitled || devUnlock }
#else
    var isPro: Bool { entitled }
#endif

    init() {
#if DEBUG
        devUnlock = UserDefaults.standard.object(forKey: "devUnlockPro") as? Bool ?? true
#endif
        updatesTask = observeTransactionUpdates()
        Task {
            await loadProduct()
            await refreshEntitlement()
        }
    }

    /// Display price string, e.g. "$3.99" (falls back while the product loads).
    var priceText: String { product?.displayPrice ?? "$3.99" }

    // MARK: Loading

    func loadProduct() async {
        do {
            product = try await Product.products(for: [Self.productID]).first
        } catch {
            lastError = "Couldn't reach the App Store."
        }
    }

    // MARK: Purchase / Restore

    func purchase() async {
        guard let product else { return }
        purchaseInProgress = true
        defer { purchaseInProgress = false }
        do {
            switch try await product.purchase() {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    entitled = true
                    await transaction.finish()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastError = "Purchase failed. Please try again."
        }
    }

    func restore() async {
        do {
            try await AppStore.sync()
        } catch {
            lastError = "Restore failed. Please try again."
        }
        await refreshEntitlement()
    }

    // MARK: Entitlement

    func refreshEntitlement() async {
        var owned = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID,
               transaction.revocationDate == nil {
                owned = true
            }
        }
        entitled = owned
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.refreshEntitlement()
            }
        }
    }
}

//
//  ProAccessManager.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      StoreKit 2 entitlement manager for Cardhold Pro (auto-renewable subscriptions: monthly
//      and annual). Single source of truth for `isPro` — checks current entitlements, listens for
//      transaction updates, and handles purchase + restore. Inject at the app root.
//      Products.storekit lets this be tested without App Store Connect.
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

    /// Must match the subscription product IDs registered in App Store Connect.
    static let monthlyID = "pro_monthly"
    static let annualID = "pro_annually"
    static let productIDs = [monthlyID, annualID]

    private(set) var products: [Product] = []
    /// True once a verified, active subscription entitlement is found.
    private(set) var entitled = false
    private(set) var purchaseInProgress = false
    var lastError: String?

    private var updatesTask: Task<Void, Never>?

#if DEBUG
    /// Developer override (DEBUG only) so the app is fully usable before IAP/CloudKit are live.
    var devUnlock = true {
        didSet { UserDefaults.standard.set(devUnlock, forKey: "devUnlockPro") }
    }
    var isPro: Bool { entitled || devUnlock }
#else
    var isPro: Bool { entitled }
#endif

    var monthly: Product? { products.first { $0.id == Self.monthlyID } }
    var annual: Product? { products.first { $0.id == Self.annualID } }

    init() {
#if DEBUG
        devUnlock = UserDefaults.standard.object(forKey: "devUnlockPro") as? Bool ?? true
#endif
        updatesTask = observeTransactionUpdates()
        Task {
            await loadProducts()
            await refreshEntitlement()
        }
    }

    // MARK: Loading

    func loadProducts() async {
        do {
            products = try await Product.products(for: Self.productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            lastError = "Couldn't reach the App Store."
        }
    }

    // MARK: Purchase / Restore

    func purchase(_ product: Product) async {
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
               Self.productIDs.contains(transaction.productID),
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

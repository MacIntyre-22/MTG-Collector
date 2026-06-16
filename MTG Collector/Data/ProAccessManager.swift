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
    private(set) var isPro = false
    private(set) var purchaseInProgress = false
    var lastError: String?

    private var updatesTask: Task<Void, Never>?

    init() {
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
                    isPro = true
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
        isPro = owned
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.refreshEntitlement()
            }
        }
    }
}

//
//  PaywallView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      The Pro upsell sheet. Lists the Pro features and offers the monthly / annual subscriptions
//      via ProAccessManager (StoreKit 2). Presented from Settings and from feature gates.
//  External Types:
//      ProAccessManager, Product
//

// MARK: Imports

import SwiftUI
import StoreKit

// MARK: Types

struct PaywallView: View {

    @Environment(ProAccessManager.self) private var pro
    @Environment(\.dismiss) private var dismiss

    private let features: [(icon: String, text: String)] = [
        ("infinity", "Unlimited binders & decks"),
        ("chart.bar.fill", "Detailed binder & deck stats"),
        ("icloud.fill", "iCloud sync across your devices"),
        ("square.and.arrow.down.fill", "Deck-list import"),
        ("camera.viewfinder", "Unlimited card scanning"),
        ("wand.and.stars", "Deck suggestions"),
        ("tablecells", "CSV export")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.yellow)
                        .padding(.top, 10)

                    Text("Cardhold Pro")
                        .font(.largeTitle.bold())

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(features, id: \.text) { feature in
                            HStack(spacing: 12) {
                                Image(systemName: feature.icon)
                                    .frame(width: 28)
                                    .foregroundStyle(.tint)
                                Text(feature.text)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .widgetStyle()

                    // Subscription options
                    if let annual = pro.annual {
                        purchaseButton(annual, caption: "Best value")
                            .buttonStyle(.borderedProminent)
                    }
                    if let monthly = pro.monthly {
                        purchaseButton(monthly, caption: nil)
                            .buttonStyle(.bordered)
                    }

                    if pro.products.isEmpty {
                        Text("The store isn't available right now. Add Products.storekit to the run scheme (for testing), or register the subscriptions in App Store Connect.")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .multilineTextAlignment(.center)
                    }
                    if let error = pro.lastError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }

                    Button("Restore Purchases") {
                        Task {
                            await pro.restore()
                            if pro.isPro { dismiss() }
                        }
                    }
                    .font(.subheadline)

                    Text("Auto-renewing subscription. Cancel anytime in Settings. Restores on all devices signed in to your Apple ID.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    // MARK: Subviews

    private func purchaseButton(_ product: Product, caption: String?) -> some View {
        Button {
            Task {
                await pro.purchase(product)
                if pro.isPro { dismiss() }
            }
        } label: {
            VStack(spacing: 2) {
                if pro.purchaseInProgress {
                    ProgressView()
                } else {
                    Text("\(product.displayName) — \(product.displayPrice)").bold()
                    if let caption {
                        Text(caption).font(.caption2).foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .disabled(pro.purchaseInProgress)
    }
}

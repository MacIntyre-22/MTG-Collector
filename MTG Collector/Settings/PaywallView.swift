//
//  PaywallView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      The Pro upsell sheet. Lists the Pro features and drives purchase / restore via
//      ProAccessManager (StoreKit 2). Presented from Settings and from feature gates.
//  External Types:
//      ProAccessManager
//

// MARK: Imports

import SwiftUI

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

                    Text("Card Hoard Pro")
                        .font(.largeTitle.bold())

                    Text("A one-time unlock for everything below.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

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

                    Button {
                        Task {
                            await pro.purchase()
                            if pro.isPro { dismiss() }
                        }
                    } label: {
                        Group {
                            if pro.purchaseInProgress {
                                ProgressView()
                            } else {
                                Text("Unlock Pro — \(pro.priceText)").bold()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(pro.purchaseInProgress || pro.product == nil)

                    Button("Restore Purchases") {
                        Task {
                            await pro.restore()
                            if pro.isPro { dismiss() }
                        }
                    }
                    .font(.subheadline)

                    Text("One-time purchase. Restores on all devices signed in to your Apple ID.")
                        .font(.caption)
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
}

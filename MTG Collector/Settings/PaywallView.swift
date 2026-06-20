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
import SwiftData
import StoreKit

// MARK: Types

struct PaywallView: View {

    @Environment(ProAccessManager.self) private var pro
    @Environment(\.dismiss) private var dismiss
    /// Read the theme directly — this sheet doesn't reliably inherit \.appTint from its presenter.
    @Query private var settingsList: [Settings]

    /// Drives the diagonal shine sweeping across the crown.
    @State private var shine = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Legal link currently open in the in-app web sheet (required by App Store Guideline 3.1.2 for
    /// subscriptions: both Terms of Use and Privacy Policy must be reachable from the paywall).
    @State private var legalLink: LegalLink?
    private struct LegalLink: Identifiable { let id = UUID(); let url: URL }
    private let privacyURL = URL(string: "https://cardhold.ca/privacy")!
    /// Apple's standard EULA — the accepted Terms of Use when the app defines no custom terms.
    private let termsURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!

    /// The user's accent colour, with the app-icon blue as a safe fallback.
    private var themeTint: Color { Color(hex: settingsList.first?.theme ?? "#007AFF") ?? .blue }

    private let features: [(icon: String, text: String)] = [
        ("infinity", "Unlimited binders & decks"),
        ("chart.bar.fill", "Detailed binder & deck stats"),
        ("icloud.fill", "iCloud sync across your devices"),
        ("arrow.up.arrow.down.square.fill", "Deck & binder import/export (TXT & CSV)"),
        ("square.and.arrow.up.fill", "Sharing"),
        ("camera.viewfinder", "Unlimited card scanning")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    shiningCrown
                        .padding(.top, 10)

                    Text("Cardhold Pro")
                        .font(BrandFont.wordmark(40, relativeTo: .largeTitle))

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
                            .buttonStyle(.glassProminent)
                            .buttonBorderShape(.capsule)
                    }
                    if let monthly = pro.monthly {
                        purchaseButton(monthly, caption: nil)
                            .buttonStyle(.glass)
                            .buttonBorderShape(.capsule)
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

                    // Required for subscriptions (Guideline 3.1.2): Terms of Use + Privacy Policy.
                    HStack(spacing: 14) {
                        Button("Terms of Use") { legalLink = LegalLink(url: termsURL) }
                        Text("·").foregroundStyle(.secondary)
                        Button("Privacy Policy") { legalLink = LegalLink(url: privacyURL) }
                    }
                    .font(.caption2)
                    .tint(themeTint)
                }
                .padding()
            }
            // Slow accent-colour drift behind the sheet (gold crown stays legible over it).
            .background { AnimatedTintBackground(tint: themeTint) }
            .sheet(item: $legalLink) { link in
                WebSheet(url: link.url)
                    .ignoresSafeArea()
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

    /// The Pro crown with a soft band of light that sweeps cleanly left→right across it, pauses
    /// off-glyph, then sweeps again. The glow behind it stays constant; only the band moves.
    private var shiningCrown: some View {
        let crown = Image(systemName: "crown.fill").font(.system(size: 56))
        return crown
            .foregroundStyle(.yellow)
            .overlay {
                // Brightness varies across the travel direction (leading→trailing) so the whole
                // height lights up evenly as the band crosses. It's tall enough to cover the crown
                // and the travel runs wider than the glyph, so each cycle has a natural pause and
                // the instant reset happens while the band is off-screen (invisible).
                LinearGradient(
                    colors: [.clear, .white.opacity(0.85), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 46, height: 160)
                .blur(radius: 4)
                .rotationEffect(.degrees(18))
                .offset(x: shine ? 130 : -130)
                .mask { crown }
            }
            .shadow(color: .yellow.opacity(0.45), radius: 8)
            .onAppear {
                // Static crown (still glow, no sweep) when Reduce Motion is on.
                guard !reduceMotion else { return }
                withAnimation(.linear(duration: 2.8).repeatForever(autoreverses: false)) {
                    shine = true
                }
            }
    }

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
                    Text("\(product.displayName) · \(product.displayPrice)\(periodSuffix(product))").bold()
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

    /// " / month", " / year", etc. for the price button, so the subscription duration is explicit.
    private func periodSuffix(_ product: Product) -> String {
        guard let period = product.subscription?.subscriptionPeriod else { return "" }
        let unit: String
        switch period.unit {
        case .day:   unit = "day"
        case .week:  unit = "week"
        case .month: unit = "month"
        case .year:  unit = "year"
        @unknown default: return ""
        }
        return period.value == 1 ? " / \(unit)" : " / \(period.value) \(unit)s"
    }
}

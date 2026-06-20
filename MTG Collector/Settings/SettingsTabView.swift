//
//  SettingsTabView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      The Settings tab, organised into clear sections: Cardhold Pro, Appearance, Currency,
//      Collection, iCloud Sync, Data, Legal and About. Layout is static — the only element that
//      appears/disappears is the iCloud sync status row (hidden while sync is off).
//  External Types:
//      Settings, ProAccessManager, AppCurrency, PaywallView, Binder, Deck, CardCache
//

// MARK: Imports

import SwiftUI
import SwiftData
import CloudKit

// MARK: Types

/// A URL wrapped for `.sheet(item:)` presentation in the in-app web sheet.
private struct WebLink: Identifiable {
    let id = UUID()
    let url: URL
}

struct SettingsTabView: View {

    // MARK: State Properties

    @Bindable var settings: Settings

    @Environment(ProAccessManager.self) private var pro
    @Environment(\.modelContext) private var modelContext
    @Query private var binders: [Binder]
    @Query private var decks: [Deck]
    @Query private var allSettings: [Settings]
    @Query private var cardCache: [CardCache]

    @State private var sync = CloudSyncMonitor.shared
    @State private var showPaywall = false
    @State private var showDeleteAlert = false
    @State private var showClearCacheAlert = false
    @State private var showSyncRestartNote = false
    /// External link currently open in the in-app web sheet (same sheet the news rows use).
    @State private var webLink: WebLink?
    /// Real CloudKit account availability (checked async). `ubiquityIdentityToken` is the wrong
    /// signal — that's iCloud Drive, which the app doesn't use; it's nil even when signed in.
    @State private var iCloudAvailable = false
#if DEBUG
    @AppStorage("homeReloadToken") private var homeReloadToken = 0
    /// When on, every collection screen force-refreshes prices on open (so the flow is testable
    /// without waiting 24h). Read by PriceRefresher via the same UserDefaults key.
    @AppStorage("devForcePriceRefresh") private var devForcePriceRefresh = false
    @State private var showPriceRefreshAlert = false
    @State private var priceRefreshCount = 0
#endif

    private let privacyURL = URL(string: "https://cardhold.ca/privacy")!
    private let scryfallTermsURL = URL(string: "https://scryfall.com/docs/api")!
    private let marketingURL = URL(string: "https://cardhold.ca")!
    private let supportEmailURL = URL(string: "mailto:support@cardhold.ca?subject=Cardhold%20Support")!
    /// App version + build come straight from the Xcode build settings (MARKETING_VERSION /
    /// CURRENT_PROJECT_VERSION) via the bundle — the same values TestFlight / App Store Connect use.
    private var appVersion: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" }
    private var buildNumber: String { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1" }

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                proSection
                appearanceSection
                currencySection
                syncSection
                dataSection
                legalSection
                aboutSection
#if DEBUG
                Section("Developer") {
                    Toggle("Unlock Pro (Dev)", isOn: Binding(
                        get: { pro.devUnlock },
                        set: { pro.devUnlock = $0 }
                    ))
                    Button("Reload Home Suggestions") {
                        HomeSuggestionsStore.invalidate()
                        homeReloadToken += 1
                    }
                    Toggle("Force Price Refresh on Open", isOn: $devForcePriceRefresh)
                    Button("Refresh Prices Now") {
                        Task {
                            priceRefreshCount = await PriceRefresher.refreshAll(context: modelContext)
                            showPriceRefreshAlert = true
                        }
                    }
                    Button("Show Onboarding") {
                        TabGuide.resetAll()
                        settings.onBoarding = true
                    }
                }
#endif
            }
            .navigationTitle("Settings")
            .task { await checkICloudAccount() }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .sheet(item: $webLink) { link in
                WebSheet(url: link.url)
                    .ignoresSafeArea()
            }
            .alert("Delete all data?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) { deleteData() }
            } message: {
                Text("This erases your binders, decks and cached cards, and shows onboarding again.")
            }
            .alert("Clear card cache?", isPresented: $showClearCacheAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) { clearCache() }
            } message: {
                Text("Card details will be re-downloaded from Scryfall as needed. Your collection is kept.")
            }
            .alert("Restart to Sync", isPresented: $showSyncRestartNote) {
                Button("OK") {}
            } message: {
                Text("iCloud Sync will start the next time you open Cardhold. On first launch it downloads your existing iCloud collection, and you'll see the progress here in Settings.")
            }
#if DEBUG
            .alert("Prices Refreshed", isPresented: $showPriceRefreshAlert) {
                Button("OK") {}
            } message: {
                Text("Re-fetched \(priceRefreshCount) cached card\(priceRefreshCount == 1 ? "" : "s") from Scryfall.")
            }
#endif
        }
    }

    // MARK: Sections

    private var appearanceSection: some View {
        Section("Appearance") {
            ColorPicker("Accent Colour", selection: Binding(
                get: { Color(hex: settings.theme) ?? .blue },
                set: { settings.theme = $0.hex }
            ))
            Picker("Card Image Quality", selection: $settings.cardImageQuality) {
                Text("Normal").tag("normal")
                Text("Large").tag("large")
            }
        }
    }

    private var currencySection: some View {
        Section {
            Picker("Display Currency", selection: Binding(
                get: { settings.appCurrency },
                set: { settings.currency = $0.rawValue }
            )) {
                ForEach(AppCurrency.allCases) { Text($0.label).tag($0) }
            }
        } header: {
            Text("Currency")
        } footer: {
            // Always shown (not gated on the selection) so the layout doesn't shift when switching.
            Text("Prices come from Scryfall. MTGO tix has no fixed exchange rate, so tix values are estimated from the USD price (≈ 1 tix = $1).")
        }
    }

    private var syncSection: some View {
        Section {
            if pro.isPro {
                Toggle("iCloud Sync", isOn: $settings.iCloudSyncEnabled)
                    .onChange(of: settings.iCloudSyncEnabled) { _, on in
                        UserDefaults.standard.set(on, forKey: "iCloudSyncEnabled")
                        if on { showSyncRestartNote = true }
                    }

                // Status row only shows while sync is on — an iCloud icon + state, with a spinner
                // while actively syncing.
                if settings.iCloudSyncEnabled {
                    HStack(spacing: 8) {
                        Image(systemName: syncIcon)
                            .foregroundStyle(syncColor)
                        Text(syncStatusText)
                            .foregroundStyle(.secondary)
                        Spacer()
                        if iCloudAvailable && sync.status == .syncing {
                            ProgressView().controlSize(.small)
                        }
                    }
                }
            } else {
                ProUpgradeButton(
                    title: "iCloud Sync is a Pro feature",
                    message: "Upgrade to sync your binders and decks across devices."
                ) { showPaywall = true }
            }
        } header: {
            Text("iCloud Sync")
        } footer: {
            Text("Your binders and decks sync across devices signed in to the same Apple ID. Sync is off until you turn it on; changes take effect after restarting Cardhold.")
        }
    }

    /// One-line connection + activity status for the sync row.
    private var syncStatusText: String {
        guard iCloudAvailable else { return "Not Connected" }
        guard settings.iCloudSyncEnabled else { return "Connected" }
        switch sync.status {
        case .syncing:  return sync.activity ?? "Syncing…"
        case .upToDate:
            if let date = sync.lastSyncDate {
                return "Updated \(date.formatted(.relative(presentation: .named)))"
            }
            return "Up to date"
        case .error:    return "Sync error"
        case .idle:     return "Connected"
        }
    }

    private var syncIcon: String {
        guard iCloudAvailable else { return "icloud.slash" }
        guard settings.iCloudSyncEnabled else { return "checkmark.icloud" }
        switch sync.status {
        case .syncing:  return "arrow.triangle.2.circlepath.icloud"
        case .upToDate: return "checkmark.icloud.fill"
        case .error:    return "exclamationmark.icloud.fill"
        case .idle:     return "checkmark.icloud"
        }
    }

    private var syncColor: Color {
        guard iCloudAvailable else { return .secondary }
        if settings.iCloudSyncEnabled && sync.status == .error { return .red }
        if settings.iCloudSyncEnabled && sync.status == .syncing { return .blue }
        return .green
    }

    private var proSection: some View {
        Section("Cardhold Pro") {
            if pro.isPro {
                Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else {
                Button("Unlock Pro") { showPaywall = true }
            }
            Button("Restore Purchases") { Task { await pro.restore() } }
        }
    }

    private var dataSection: some View {
        Section("Data") {
            Button("Clear Card Cache") { showClearCacheAlert = true }
            Button("Delete Collection Data", role: .destructive) { showDeleteAlert = true }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            Text("Cardhold is an independent app and is not affiliated with Wizards of the Coast. It ships with no card content of its own. All Magic: The Gathering names, text and images are owned by Wizards of the Coast LLC, fetched and cached locally from the Scryfall API and used within Scryfall's terms.")
                .font(.caption)
                .foregroundStyle(.secondary)
            webLinkRow("Privacy Policy", url: privacyURL)
            webLinkRow("Scryfall API Terms", url: scryfallTermsURL)
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text("\(appVersion) (\(buildNumber))").foregroundStyle(.secondary)
            }
            webLinkRow("cardhold.ca", url: marketingURL)
            // Opens the Mail composer to support@cardhold.ca (mailto can't use the web sheet).
            Link(destination: supportEmailURL) {
                HStack {
                    Text("Email Support")
                    Spacer()
                    Image(systemName: "envelope")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("About")
        } footer: {
            Text("Need a hand, found a bug, or have a feature idea? Get in touch and we'll get back to you.")
        }
    }

    /// A tappable row that opens a URL in the in-app web sheet (same sheet the news rows use),
    /// instead of leaving the app for Safari.
    private func webLinkRow(_ title: String, url: URL) -> some View {
        Button {
            webLink = WebLink(url: url)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: Actions

    private func deleteData() {
        for binder in binders {
            StatsStore.remove(for: binder.id, context: modelContext)
            modelContext.delete(binder)
        }
        for deck in decks {
            StatsStore.remove(for: deck.id, context: modelContext)
            modelContext.delete(deck)
        }
        for cached in cardCache { modelContext.delete(cached) }
        for setting in allSettings { setting.onBoarding = true }
    }

    private func clearCache() {
        for cached in cardCache { modelContext.delete(cached) }
    }

    /// Check whether an iCloud account is signed in (the correct signal for CloudKit, unlike
    /// ubiquityIdentityToken which tracks iCloud Drive).
    private func checkICloudAccount() async {
        let status = try? await CKContainer(identifier: "iCloud.net.benmacintyre.cardhold").accountStatus()
        iCloudAvailable = (status == .available)
    }
}

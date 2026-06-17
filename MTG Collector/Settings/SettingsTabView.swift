//
//  SettingsTabView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      The Settings tab, organised into clear sections: Appearance, Currency, iCloud Sync,
//      Pro, Collection Defaults, Data, Legal and Developer.
//  External Types:
//      Settings, ProAccessManager, AppCurrency, PaywallView, Binder, Deck, CardCache
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct SettingsTabView: View {

    // MARK: State Properties

    @Bindable var settings: Settings

    @Environment(ProAccessManager.self) private var pro
    @Environment(\.modelContext) private var modelContext
    @Query private var binders: [Binder]
    @Query private var decks: [Deck]
    @Query private var allSettings: [Settings]
    @Query private var cardCache: [CardCache]

    @State private var showPaywall = false
    @State private var showDeleteAlert = false
    @State private var showClearCacheAlert = false

    private let privacyURL = URL(string: "https://benmacintyre.net/cardhoard/privacy")!

    private var iCloudAvailable: Bool { FileManager.default.ubiquityIdentityToken != nil }
    private var appVersion: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0" }
    private var buildNumber: String { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1" }

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                currencySection
                syncSection
                proSection
                defaultsSection
                dataSection
                legalSection
                developerSection
#if DEBUG
                Section("Developer") {
                    Toggle("Unlock Pro (Dev)", isOn: Binding(
                        get: { pro.devUnlock },
                        set: { pro.devUnlock = $0 }
                    ))
                }
#endif
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) { PaywallView() }
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
        }
    }

    // MARK: Sections

    private var appearanceSection: some View {
        Section("Appearance") {
            ColorPicker("Accent Colour", selection: Binding(
                get: { Color(hex: settings.theme) ?? .orange },
                set: { settings.theme = $0.hex }
            ))
            Picker("Card Image Quality", selection: $settings.cardImageQuality) {
                Text("Normal").tag("normal")
                Text("Large").tag("large")
            }
        }
    }

    private var currencySection: some View {
        Section("Currency") {
            Picker("Display Currency", selection: Binding(
                get: { settings.appCurrency },
                set: { settings.currency = $0.rawValue }
            )) {
                ForEach(AppCurrency.allCases) { Text($0.label).tag($0) }
            }
        }
    }

    private var syncSection: some View {
        Section {
            Toggle("iCloud Sync", isOn: $settings.iCloudSyncEnabled)
                .onChange(of: settings.iCloudSyncEnabled) { _, on in
                    UserDefaults.standard.set(on, forKey: "iCloudSyncEnabled")
                }
            HStack {
                Text("Account")
                Spacer()
                Text(iCloudAvailable ? "Connected" : "Sign in to iCloud")
                    .foregroundStyle(iCloudAvailable ? .green : .secondary)
            }
        } header: {
            Text("iCloud Sync")
        } footer: {
            Text("Changes to sync take effect after restarting the app.")
        }
    }

    private var proSection: some View {
        Section("Card Hoard Pro") {
            if pro.isPro {
                Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else {
                Button("Unlock Pro — \(pro.priceText)") { showPaywall = true }
            }
            Button("Restore Purchases") { Task { await pro.restore() } }
        }
    }

    private var defaultsSection: some View {
        Section("Collection Defaults") {
            Toggle("Show card previews by default", isOn: $settings.defaultShowPreviews)
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
            Text("Card Hoard is an independent app and is not affiliated with Wizards of the Coast. All Magic: The Gathering content belongs to Wizards of the Coast LLC. Card data and images are provided by Scryfall.")
                .font(.caption)
                .foregroundStyle(.secondary)
            Link("Privacy Policy", destination: privacyURL)
            Link("Scryfall", destination: URL(string: "https://scryfall.com")!)
        }
    }

    private var developerSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("\(appVersion) (\(buildNumber))").foregroundStyle(.secondary)
            }
            Link("benmacintyre.net", destination: URL(string: "https://benmacintyre.net")!)
        }
    }

    // MARK: Actions

    private func deleteData() {
        for binder in binders { modelContext.delete(binder) }
        for deck in decks { modelContext.delete(deck) }
        for cached in cardCache { modelContext.delete(cached) }
        for setting in allSettings { setting.onBoarding = true }
    }

    private func clearCache() {
        for cached in cardCache { modelContext.delete(cached) }
    }
}

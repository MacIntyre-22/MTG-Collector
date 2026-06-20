//
//  MTGTab_View.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-19.
//  Purpose:
//      Contains all the tabs for the app, also controls the settings and onboarding
//  External Types:
//      Settings, HomeTabView, SearchTabView, MyCollectionTabView, SettingsTabView, OnBoardingView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

/// A card list awaiting a create sheet, carried into `.sheet(item:)` (String isn't Identifiable).
private struct ImportText: Identifiable {
    let id = UUID()
    let text: String
}

struct MTG_TabView: View {
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @Environment(AppRouter.self) private var router
    @Query var settingsQuery: [Settings]
    @State private var pro = ProAccessManager()
    @State private var sync = CloudSyncMonitor.shared
    @State private var importingShare = false
    @State private var shareError: String?
    /// A .txt / .csv opened from Files: hold its text while the user picks deck or binder, then route
    /// it into the matching create sheet pre-filled.
    @State private var pendingImportText: String?
    @State private var showImportChooser = false
    @State private var showImportPaywall = false
    @State private var deckImport: ImportText?
    @State private var binderImport: ImportText?
    /// The per-tab feature intro currently being shown (once per tab, after onboarding).
    @State private var activeGuide: TabGuide?
    
    // MARK: Computed Properties
    
    var settings: Settings {
            /// grab the first settings item so it is always the same
            if let existing = settingsQuery.first {
                return existing
            } else {
                /// if it doesn't exists (On first app launch)
                /// create an instance
                ///
                let newSettings = Settings()
                modelContext.insert(newSettings)
                return newSettings
            }
        }
    
    // MARK: View

    /// Resolved accent colour from the user's theme, with a safe fallback.
    private var tint: Color { Color(hex: settings.theme) ?? .blue }

    /// A tab-bar-sized template render of the app icon. Raw image assets render at their
    /// native size inside `.tabItem` (resizable modifiers are ignored), so we downscale once.
    private static let tabIcon: UIImage = {
        let size = CGSize(width: 26, height: 26)
        let base = UIImage(named: "CardholdIcon") ?? UIImage()
        let rendered = UIGraphicsImageRenderer(size: size).image { _ in
            base.draw(in: CGRect(origin: .zero, size: size))
        }
        return rendered.withRenderingMode(.alwaysTemplate)
    }()

    var body: some View {
        @Bindable var router = router
        ZStack {
            TabView(selection: $router.selectedTab) {
                HomeTabView()
                    .tabItem({
                        Label("Home", systemImage: "house")
                    })
                    .tag(AppTab.home)
                SearchTabView()
                    .tabItem({
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    })
                    .tag(AppTab.search)

                MyCollectionTabView()
                    .tabItem({
                        Image(uiImage: Self.tabIcon)
                        Text("My Hold")
                    })
                    .tag(AppTab.collection)

                SettingsTabView(settings: settings)
                    .tabItem({
                        Image(systemName: "gearshape")
                        Text("Settings")
                    })
                    .tag(AppTab.settings)
            }
            .tint(tint)

            if settings.onBoarding {
                OnBoardingView() {
                    settings.onBoarding = false
                }
                .ignoresSafeArea()
            }
        }
        .tint(tint)
        .environment(pro)
        .environment(\.appTint, tint)
        .environment(\.appCurrency, settings.appCurrency)
        .environment(\.beginnerHints, settings.beginnerHints)
        .onChange(of: pro.isPro) { _, isPro in
            // mirror the verified entitlement into the persisted Settings flag for offline gating
            settings.isPro = isPro
            // …and into UserDefaults, where AppModelContainer reads it at next launch to decide
            // whether CloudKit sync may attach (sync is Pro-only).
            UserDefaults.standard.set(isPro, forKey: "isProEntitled")
        }
        // Refresh FX rates (≤ once/day) then recompute stats on app open so values are current
        // everywhere (Home, My Hold) without visiting a screen. Rates first so the canonical-USD
        // fallback (EUR→USD) uses fresh numbers; conversion to the display currency is live anyway.
        .task {
            // Make sure the permanent "My Hold" catch-all exists before any tab needs it, so the
            // user never has to open the My Hold tab to bring it into being.
            GeneralCollection.ensure(context: modelContext)
            // Seed the entitlement mirror so the next launch's container has a value to read.
            UserDefaults.standard.set(pro.isPro, forKey: "isProEntitled")
            await CurrencyRates.shared.refreshIfStale()
            await recomputeAllStats()
            // Returning users (onboarding already done) get the current tab's intro if unseen.
            if !settings.onBoarding { presentGuide(for: router.selectedTab) }
        }
        // Show each tab's one-time feature intro the first time it's opened.
        .onChange(of: router.selectedTab) { _, tab in
            presentGuide(for: tab)
        }
        // First launch: once onboarding is dismissed, offer the Home intro.
        .onChange(of: settings.onBoarding) { _, onboarding in
            guard !onboarding else { return }
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                presentGuide(for: router.selectedTab)
            }
        }
        .sheet(item: $activeGuide) { guide in
            // Sheets don't reliably inherit our custom \.appTint, so inject the theme tint here
            // (otherwise it falls back to the orange default).
            TabGuideSheet(guide: guide)
                .environment(\.appTint, tint)
                .tint(tint)
        }
        // After a CloudKit import (data pulled from another device), recompute the local stats —
        // stats don't sync, so the receiving device rebuilds them from the freshly-synced cards.
        .onChange(of: sync.importGeneration) { _, _ in
            Task { await recomputeAllStats() }
        }
        // Incoming shared-collection links — Universal Link (web) and any direct open.
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
            if let url = activity.webpageURL { handleIncomingURL(url) }
        }
        .onOpenURL { url in handleIncomingURL(url) }
        .overlay {
            if importingShare {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Opening shared collection…")
                        .padding(24)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .alert("Couldn't Open Link", isPresented: .constant(shareError != nil)) {
            Button("OK") { shareError = nil }
        } message: {
            Text(shareError ?? "")
        }
        // A card-list file was opened from Files — ask which kind of collection to build, then open
        // the matching create sheet pre-filled with the list.
        .confirmationDialog("Import Card List", isPresented: $showImportChooser, titleVisibility: .visible) {
            Button("New Deck") {
                if let text = pendingImportText { deckImport = ImportText(text: text) }
                pendingImportText = nil
            }
            Button("New Binder") {
                if let text = pendingImportText { binderImport = ImportText(text: text) }
                pendingImportText = nil
            }
            Button("Cancel", role: .cancel) { pendingImportText = nil }
        } message: {
            Text("Create a new deck or binder from this file.")
        }
        .sheet(item: $deckImport) { item in
            NewDeckSheet(initialImportText: item.text)
        }
        .sheet(item: $binderImport) { item in
            NewBinderSheet(initialImportText: item.text)
        }
        .sheet(isPresented: $showImportPaywall) { PaywallView() }
    }

    // MARK: Tab feature intros

    /// Present a tab's one-time feature intro, unless onboarding is active, the tab has no guide
    /// (Settings), or it's already been seen. Marks it seen as it's shown so it never repeats.
    private func presentGuide(for tab: AppTab) {
        guard !settings.onBoarding else { return }
        guard activeGuide == nil else { return }
        guard let guide = TabGuide.guide(for: tab) else { return }
        guard !UserDefaults.standard.bool(forKey: guide.seenKey) else { return }
        UserDefaults.standard.set(true, forKey: guide.seenKey)
        activeGuide = guide
    }

    // MARK: Stats recompute after sync

    /// Rebuild local stats for every collection after a sync import. Primes card data first so
    /// prices/types are present, then recomputes (stats are local-only and don't sync down).
    @MainActor
    private func recomputeAllStats() async {
        let binders = (try? modelContext.fetch(FetchDescriptor<Binder>())) ?? []
        let decks = (try? modelContext.fetch(FetchDescriptor<Deck>())) ?? []

        let ids = binders.flatMap { $0.cards.map(\.scryfallCardID) }
            + decks.flatMap { $0.allCardIDs }
        await CardStore.prime(ids, context: modelContext)

        for binder in binders where !binder.isDeleted {
            StatsUpdater.update(binder, context: modelContext)
        }
        for deck in decks where !deck.isDeleted {
            StatsUpdater.update(deck, context: modelContext)
        }
    }

    // MARK: Shared-link import

    /// Fetch a shared collection snapshot, import it as a fresh copy, and open it. Receiving a
    /// share is free (so anyone can open a shared link); creating one is the Pro feature.
    private func handleIncomingURL(_ url: URL) {
        // A .txt / .csv shared or opened from Files → import chooser, not a shared-collection link.
        if url.isFileURL {
            importCardListFile(url)
            return
        }

        guard let id = CollectionShareService.shareID(from: url) else { return }
        importingShare = true
        Task {
            do {
                let (snapshot, cover) = try await CollectionShareService.fetch(id: id)
                let imported = CollectionSnapshotImporter.importSnapshot(snapshot, cover: cover, context: modelContext)
                await CardStore.prime(imported.cardIDs, context: modelContext)
                importingShare = false
                switch imported.kind {
                case .deck:   router.openDeck(id: imported.id)
                case .binder: router.openBinder(id: imported.id)
                }
            } catch {
                importingShare = false
                shareError = error.localizedDescription
            }
        }
    }

    // MARK: File import

    /// Read a card-list file (copied into our container, or opened in place from Files) and, if it
    /// has content, raise the deck/binder chooser. Switches to My Hold so the new collection lands
    /// in view once created.
    private func importCardListFile(_ url: URL) {
        let scoped = url.startAccessingSecurityScopedResource()
        defer { if scoped { url.stopAccessingSecurityScopedResource() } }

        guard let text = try? String(contentsOf: url, encoding: .utf8),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            shareError = "That file was empty or couldn't be read as text."
            return
        }
        router.selectedTab = .collection
        // Import is a Pro feature — non-subscribers get the paywall instead of the chooser.
        guard pro.isPro else {
            showImportPaywall = true
            return
        }
        pendingImportText = text
        showImportChooser = true
    }
}


//
//  CardholdShortcuts.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      App Intents / Siri Shortcuts. Exposes the app's key actions to Siri, Spotlight and the
//      Action button: search for a card, open the collection, scan a card, and read back the
//      collection's total value. UI-routing intents hand off to AppRouter; the value intent
//      reads the shared SwiftData store directly so it can answer without opening the app.
//  External Types:
//      AppRouter, AppModelContainer, Binder, Deck, Settings, Collection
//

// MARK: Imports

import AppIntents
import SwiftData

// MARK: Search

/// "Search Cards" — opens the app on the Search tab with the search field focused and the
/// keyboard up, ready to type. No parameter, so iOS never shows its own text-field prompt.
struct SearchCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Search Cards"
    static var description = IntentDescription("Open Cardhold's search ready to look up a card.")
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        AppRouter.shared.openSearch()
        return .result()
    }
}

// MARK: Scan

/// "Scan a card" — opens the app on the Search tab and launches the card scanner.
struct ScanCardIntent: AppIntent {
    static var title: LocalizedStringResource = "Scan a Card"
    static var description = IntentDescription("Open Cardhold's camera scanner to identify a card.")
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        AppRouter.shared.scanCard()
        return .result()
    }
}

// MARK: Open Collection

/// "Open My Hold" — opens the app on the My Hold tab.
struct OpenCollectionIntent: AppIntent {
    static var title: LocalizedStringResource = "Open My Hold"
    static var description = IntentDescription("Jump straight to your Cardhold collection.")
    static var openAppWhenRun = true

    @MainActor
    func perform() async throws -> some IntentResult {
        AppRouter.shared.showCollection()
        return .result()
    }
}

// MARK: Collection Value

/// "What's my collection worth?" — reads the stored stats and answers with the total value.
/// Runs without opening the app: it reads the shared SwiftData store directly.
struct CollectionValueIntent: AppIntent {
    static var title: LocalizedStringResource = "Collection Value"
    static var description = IntentDescription("Hear the total value of everything in your Cardhold collection.")

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(AppModelContainer.shared)

        let binders = (try? context.fetch(FetchDescriptor<Binder>())) ?? []
        let decks = (try? context.fetch(FetchDescriptor<Deck>())) ?? []
        let settings = (try? context.fetch(FetchDescriptor<Settings>()))?.first
        let currency = settings?.appCurrency ?? .usd

        // Only collections that count toward the user's owned totals (matches the My Hold summary).
        let collections: [Collection] =
            binders.filter { !$0.isDeleted && $0.inCollection }.map { $0 as Collection } +
            decks.filter { !$0.isDeleted && $0.inCollection }.map { $0 as Collection }

        // Stats live in the local cache store — fetch all and index by collection id.
        let allStats = (try? context.fetch(FetchDescriptor<CollectionStats>())) ?? []
        let statsByID = Dictionary(allStats.map { ($0.collectionID, $0) }, uniquingKeysWith: { first, _ in first })

        let total = collections.reduce(0.0) { $0 + currency.total(statsByID[$1.id]) }
        let cards = collections.reduce(0) { $0 + (statsByID[$1.id]?.totalCards ?? 0) }

        let formatted = currency.format(total)
        return .result(dialog: "Your collection is worth \(formatted) across \(cards) cards.")
    }
}

// MARK: Open Collection by name

/// A binder or deck, exposed to App Intents so the user can pick one by name (Shortcuts/Siri).
struct CollectionEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Collection")
    static var defaultQuery = CollectionEntityQuery()

    var id: String
    var name: String
    /// Decks route differently from binders, so carry the kind on the entity.
    var isDeck: Bool

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)", subtitle: isDeck ? "Deck" : "Binder")
    }
}

/// Supplies the user's binders + decks to the picker, reading the shared store directly.
struct CollectionEntityQuery: EntityQuery {

    @MainActor
    func entities(for identifiers: [String]) async throws -> [CollectionEntity] {
        all().filter { identifiers.contains($0.id) }
    }

    @MainActor
    func suggestedEntities() async throws -> [CollectionEntity] {
        all()
    }

    @MainActor
    private func all() -> [CollectionEntity] {
        let context = ModelContext(AppModelContainer.shared)
        let binders = (try? context.fetch(FetchDescriptor<Binder>())) ?? []
        let decks = (try? context.fetch(FetchDescriptor<Deck>())) ?? []
        let binderEntities = binders
            .filter { !$0.isDeleted && !$0.isGeneral }
            .map { CollectionEntity(id: $0.id, name: $0.name, isDeck: false) }
        let deckEntities = decks
            .filter { !$0.isDeleted }
            .map { CollectionEntity(id: $0.id, name: $0.name, isDeck: true) }
        return (binderEntities + deckEntities).sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}

/// "Open ‹name›" — jumps straight to a chosen binder or deck.
struct OpenCollectionByNameIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Collection"
    static var description = IntentDescription("Open a specific binder or deck in Cardhold.")
    static var openAppWhenRun = true

    @Parameter(title: "Collection")
    var collection: CollectionEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$collection)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        if collection.isDeck {
            AppRouter.shared.openDeck(id: collection.id)
        } else {
            AppRouter.shared.openBinder(id: collection.id)
        }
        return .result()
    }
}

// MARK: Shortcuts Provider

/// Surfaces the intents to Siri / Spotlight with spoken phrases. `\(.applicationName)` lets the
/// user say "Cardhold" in place of the app name.
struct CardholdShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SearchCardIntent(),
            phrases: [
                "Search for a card in \(.applicationName)",
                "Search \(.applicationName)"
            ],
            shortTitle: "Search Cards",
            systemImageName: "magnifyingglass"
        )
        AppShortcut(
            intent: ScanCardIntent(),
            phrases: [
                "Scan a card with \(.applicationName)",
                "Scan a card in \(.applicationName)"
            ],
            shortTitle: "Scan Card",
            systemImageName: "camera.viewfinder"
        )
        AppShortcut(
            intent: OpenCollectionIntent(),
            phrases: [
                "Open my \(.applicationName) hold",
                "Show my hold in \(.applicationName)"
            ],
            shortTitle: "My Hold",
            systemImageName: "rectangle.stack.fill"
        )
        AppShortcut(
            intent: OpenCollectionByNameIntent(),
            phrases: [
                "Open \(\.$collection) in \(.applicationName)",
                "Open my \(\.$collection) in \(.applicationName)"
            ],
            shortTitle: "Open Collection",
            systemImageName: "folder"
        )
        AppShortcut(
            intent: CollectionValueIntent(),
            phrases: [
                "What's my \(.applicationName) collection worth",
                "Show my \(.applicationName) collection value"
            ],
            shortTitle: "Collection Value",
            systemImageName: "dollarsign.circle"
        )
    }
}

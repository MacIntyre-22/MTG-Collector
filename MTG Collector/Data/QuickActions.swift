//
//  QuickActions.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Home Screen quick actions — the shortcuts shown when you long-press the app icon. The
//      items themselves are declared in Info.plist (UIApplicationShortcutItems); this file wires
//      the taps (cold launch and warm) through a scene delegate into AppRouter so they land on
//      the right screen.
//  External Types:
//      AppRouter
//

// MARK: Imports

import UIKit

// MARK: Action Types

/// Identifiers shared with the Info.plist UIApplicationShortcutItems entries.
enum QuickAction: String {
    case search     = "net.benmacintyre.cardhold.search"
    case scan       = "net.benmacintyre.cardhold.scan"
    case collection = "net.benmacintyre.cardhold.collection"
    /// A dynamic "open this binder/deck" item — its id + kind ride in the shortcut's userInfo.
    case open       = "net.benmacintyre.cardhold.open"

    /// Route this action through the shared router. `.open` is handled separately (it needs the
    /// item's payload), so it's a no-op here.
    @MainActor
    func run() {
        switch self {
        case .search:     AppRouter.shared.openSearch()
        case .scan:       AppRouter.shared.scanCard()
        case .collection: AppRouter.shared.showCollection()
        case .open:       break
        }
    }

    /// Refresh the dynamic Home Screen actions with the user's pinned (else most-recent) collections,
    /// so long-pressing the icon can jump straight into one. iOS lists the static Info.plist items
    /// first, so these fill the remaining slot(s) — effectively a contextual "Open ‹name›".
    @MainActor
    static func refresh(binders: [Binder], decks: [Deck]) {
        struct Item { let id: String; let name: String; let isDeck: Bool; let pinned: Bool; let editedAt: Date }
        let items = binders.filter { !$0.isDeleted && !$0.isGeneral }
                .map { Item(id: $0.id, name: $0.name, isDeck: false, pinned: $0.pinned, editedAt: $0.editedAt) }
            + decks.filter { !$0.isDeleted }
                .map { Item(id: $0.id, name: $0.name, isDeck: true, pinned: $0.pinned, editedAt: $0.editedAt) }

        let top = items
            .sorted { $0.pinned != $1.pinned ? $0.pinned : $0.editedAt > $1.editedAt }
            .prefix(2)

        UIApplication.shared.shortcutItems = top.map { item in
            UIApplicationShortcutItem(
                type: QuickAction.open.rawValue,
                localizedTitle: item.name,
                localizedSubtitle: item.isDeck ? "Deck" : "Binder",
                icon: UIApplicationShortcutIcon(systemImageName: item.isDeck ? "rectangle.stack" : "folder"),
                userInfo: ["id": item.id as NSString, "kind": (item.isDeck ? "deck" : "binder") as NSString]
            )
        }
    }
}

// MARK: Delegates

/// Routes incoming Home Screen quick actions to a scene delegate. Registered via
/// `@UIApplicationDelegateAdaptor` on the App so SwiftUI keeps owning the window content.
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = QuickActionSceneDelegate.self
        return config
    }
}

/// Handles quick actions for both cold launch (`willConnectTo`) and while running
/// (`performActionFor`). The action is applied to AppRouter, which the SwiftUI views observe.
final class QuickActionSceneDelegate: NSObject, UIWindowSceneDelegate {

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let item = connectionOptions.shortcutItem {
            apply(item)
        }
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        completionHandler(apply(shortcutItem))
    }

    @discardableResult
    private func apply(_ item: UIApplicationShortcutItem) -> Bool {
        // Dynamic "open a collection" items carry their id + kind in userInfo.
        if item.type == QuickAction.open.rawValue {
            guard let id = item.userInfo?["id"] as? String,
                  let kind = item.userInfo?["kind"] as? String else { return false }
            Task { @MainActor in
                if kind == "deck" { AppRouter.shared.openDeck(id: id) }
                else { AppRouter.shared.openBinder(id: id) }
            }
            return true
        }
        guard let action = QuickAction(rawValue: item.type) else { return false }
        Task { @MainActor in action.run() }
        return true
    }
}

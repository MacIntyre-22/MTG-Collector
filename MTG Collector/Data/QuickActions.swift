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

    /// Route this action through the shared router.
    @MainActor
    func run() {
        switch self {
        case .search:     AppRouter.shared.openSearch()
        case .scan:       AppRouter.shared.scanCard()
        case .collection: AppRouter.shared.showCollection()
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
        guard let action = QuickAction(rawValue: item.type) else { return false }
        Task { @MainActor in action.run() }
        return true
    }
}

# Quick Access (Spotlight & App Intents)

## Summary

Saved binders and decks are indexed in **Spotlight** so they appear in iOS Search and open directly
in the app. Key actions are exposed as **App Intents / Siri Shortcuts** (and the iPhone Action
button): search for a card, scan a card, open a collection, and report total collection value. A
shared `AppRouter` is the single navigation coordinator that Spotlight results and intents route
through.

## Capabilities

- Spotlight indexing of binders/decks (with cover image), re-indexed cheaply on launch.
- Tapping a Spotlight result routes to the indexed binder/deck.
- Siri Shortcuts / App Intents: "Search for [card]", "Scan a card", "Open [collection]",
  "What's my collection value".
- Collection-value intent respects the `inCollection` flag.

## Code map

| Piece | Location |
|---|---|
| Spotlight index/remove/handle | `MTG Collector/Data/Spotlight.swift:21` |
| App Intents (4) + shortcuts provider | `MTG Collector/Data/CardholdShortcuts.swift:104` (intents `:24`, `:39`, `:54`, `:70`) |
| Navigation coordinator + tabs | `MTG Collector/Data/AppRouter.swift:32` (`AppTab:22`) |
| Spotlight result routing | `MTG Collector/MTG_CollectorApp.swift` (`onContinueUserActivity(CSSearchableItemActionType)`) |
| Re-index on launch + deep-link consume | `MTG Collector/MyCollection/MyCollectionTabView.swift` (`indexForSpotlight`, `consumeRouterRequests`) |

## Notes

- Spotlight and App Intents share the same indexing/routing work.
- The collection-value intent filters to `inCollection` collections (matches the whole-collection widget).

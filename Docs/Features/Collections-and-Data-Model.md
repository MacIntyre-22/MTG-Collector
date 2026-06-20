# Collections & Data Model

## Summary

Cards are organised into **Binders** and **Decks**, both inheriting from a shared `Collection`
`@Model` base (iOS 26 class inheritance). The My Hold tab shows a whole-collection summary, buttons
into the Binders and Decks lists, and a permanent **"My Hold"** catch-all binder (`isGeneral`)
auto-created at launch. Card membership is stored lightweight (`CardEntry` = Scryfall ID + quantity +
flags); full card data lives separately in a local-only `CardCache`, so the synced data stays small
and CloudKit-legal.

## Capabilities

- `Collection` base shares id/name/notes/dates/preview+control flags/pinned/cover/sort/`inCollection`.
- Binders add a cover image + cards; Decks add rule type, leaders, and main/side/maybe boards.
- "My Hold" catch-all auto-created at app launch (deterministic dedupe across synced devices).
- Soft-delete (`isDeleted`) on synced models, filtered out of all queries.
- "Count in Collection Totals" toggle (`inCollection`) controls whole-collection aggregation.
- Empty states on every list/grid (binders, decks, binder cards, deck boards, My Hold).

## Code map

| Piece | Location |
|---|---|
| `Collection` base model | `MTG Collector/Data/Models/Collection.swift:23` |
| `Binder` model | `MTG Collector/Data/Models/Binder.swift:24` |
| `Deck` model | `MTG Collector/Data/Models/Deck.swift:23` |
| `CardEntry` (synced membership) + `CardFinish` | `MTG Collector/Data/Models/CardEntry.swift:40` (`CardFinish:23`) |
| `CardCache` (local-only full card data) | `MTG Collector/Data/Models/CardCache.swift:22` |
| My Hold tab (summary, links, general section, empty states) | `MTG Collector/MyCollection/MyCollectionTabView.swift:24` |
| "My Hold" catch-all ensure/dedupe | `MTG Collector/Data/GeneralCollection.swift` (`ensure`) |
| Binder list (+ empty state) | `MTG Collector/MyCollection/Views/AllBindersView.swift:21` |
| Deck list (+ empty state) | `MTG Collector/MyCollection/Views/AllDecksView.swift:18` |
| Binder detail (+ empty/filtered states) | `MTG Collector/MyCollection/Views/BinderView.swift:19` |
| Deck detail | `MTG Collector/MyCollection/Views/DeckView.swift:20` |
| Shared collection scaffold (cover background + header) | `MTG Collector/MyCollection/Views/CollectionScreen.swift:44` |
| Card-ID → card cache resolver | `MTG Collector/Data/CardStore.swift:22` |

## Notes

- `GeneralCollection.ensure(context:)` runs at app launch (in `MTG_TabView.task`) so My Hold exists
  before the user opens the tab.
- See [Collection Stats](Collection-Stats.md), [iCloud Sync](iCloud-Sync.md),
  [Price Refresh & Cache](Price-Refresh-and-Cache.md).

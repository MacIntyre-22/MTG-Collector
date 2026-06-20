# Price Refresh & Cache

## Summary

Full card data (including prices) is cached locally in `CardCache`, keyed by Scryfall ID with a
`fetchedAt` timestamp. When a collection screen opens, `PriceRefresher` finds cached cards whose
prices are older than 24h, re-fetches them in batches of 75 via Scryfall's `/cards/collection`,
re-caches them, updates the collection's stats, and shows a transient **"Prices updated · N cards"**
banner. It's stale-only, so most opens are a cheap no-op. A dev toggle can force a refresh on every
open for testing.

## Capabilities

- On-open, stale-only (24h) price refresh for binders, decks, and My Hold.
- Batched re-fetch (75/request) + re-cache + stats update.
- Transient top banner notification when prices actually changed.
- Dev controls: "Force Price Refresh on Open" toggle + "Refresh Prices Now" (force-refresh all).

## Code map

| Piece | Location |
|---|---|
| Price refresher (stale check, batch, refresh-all) | `MTG Collector/Data/PriceRefresher.swift:24` (`refresh:35`, `refreshCollection:60`, `refreshAll:66`) |
| Card cache model | `MTG Collector/Data/Models/CardCache.swift:22` |
| Cache resolver / upsert (updates `fetchedAt`) | `MTG Collector/Data/CardStore.swift:22` |
| Transient banner + `.priceRefreshBanner` modifier | `MTG Collector/SharedViews/PriceRefreshBanner.swift:17` |
| On-open hooks | `BinderView.swift`, `DeckView.swift`, `MyCollectionTabView.swift` (`.task` → `PriceRefresher.refreshCollection`) |
| Dev controls | `MTG Collector/Settings/SettingsTabView.swift` (`#if DEBUG` Developer section) |
| Currency conversion / FX rates | `MTG Collector/Data/CurrencyRates.swift:24` |

## Notes

- The dev force flag is read by `PriceRefresher` via the `devForcePriceRefresh` UserDefaults key.
- Prices display in the user's selected currency (USD/EUR/CAD/tix; tix estimated from USD).

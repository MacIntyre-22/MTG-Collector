# Phase 2 — Backend & Data Model Rework (handoff)

Done on branch `phase-2` (branched from `phase-1`). **Not built/tested — I'm on Windows.** Compile on your Mac before merging to `appstore`.

## What changed

### Card data is now value types
- `Card`, `ImageURIs`, `Prices`, `PurchaseURIs`, `RelatedCardObject`, `CardFace` are **Codable structs** (no longer `@Model`). New `RelatedURIs` struct added.
- `SFAPI.JSONtoModel` is now a flat struct mapping (was ~90 lines of nested `@Model` construction).

### New Scryfall fields
- Card: `producedMana`, `edhrecRank`, `setName`, `artist`, `collectorNumber`, `scryfallURI`, `rulingsURI`, `relatedURIs`
- Prices: `eur`, `eurFoil`, `tix`
- RelatedCardObject: `component`
- CardFace: `producedMana`, `flavorText`

### Synced vs local split (your "only IDs in the cloud" requirement)
- `CardEntry` (synced) now holds only `scryfallCardID` + metadata (`quantity`, `isFoil`, `favourite`, `dateAdded`, `isDeleted`, `updatedAt`).
- `CardCache` (**local-only** `@Model`) holds full `Card` data keyed by Scryfall ID + `fetchedAt`.
- `CardStore` resolves entries → cards (cache hit, else fetch from Scryfall and cache).
- Two-store `ModelContainer`: "Synced" config (collections/IDs/stats/settings) + "Cache" config (CardCache, SetInfo). **No relationship crosses the two stores** — that's what keeps synced data small.

### Collection hierarchy
- New `@Model class Collection` base (id, name, notes, dates, presentation flags, `sortBy`, `isDeleted`, `updatedAt`, one-to-one `stats`).
- `Binder` and `Deck` now inherit from it. `Binder` adds `isGeneral` (for the future General Collection).
- `CollectionStats` `@Model` stores price/curve/breakdowns; `StatsUpdater` recomputes it on add/remove/move and when stat sheets/collection views appear.
- Card-data stats moved OFF `Binder`/`Deck` computed props (they can't read card data anymore). Thin convenience accessors (`binder.totalPrice` etc.) now read the stored stats. `Deck.isLegal` is stored and maintained by `StatsUpdater`.

### Schema / migration
- `AppSchema.swift`: `SchemaV1` (VersionedSchema) + `AppMigrationPlan` (no stages yet — V1 is initial). Wired into the container.

## ⚠️ Needs your Mac / device — gated on purpose

1. **CloudKit is OFF** (`cloudKitDatabase: .none`). Search `TODO(device)` in `MTG_CollectorApp.swift`. To enable Pro sync (Phase 6): flip the synced config to `.automatic`, enable iCloud + CloudKit capability in Xcode, test on a real device.
2. **SwiftData `@Model` class inheritance** (Collection→Binder/Deck) and **storing a Codable `Card` struct inside `CardCache`** are both supported features but should be smoke-tested on first launch (create a binder, add a card, reopen).
3. **CloudKit optionalisation**: when you turn sync on, CloudKit wants relationship arrays optional. Currently `cards`/`mainboard`/etc. are `[CardEntry] = []`. Since nothing has shipped yet this is still a free pre-v1 schema change — do it alongside enabling CloudKit, then finalise `SchemaV1`.
4. **Existing dev data**: this schema is not migration-compatible with the old `Card @Model` store. Delete the app from the simulator/device once before running (no shipped users, so safe).

## Behaviour notes
- On a fresh device after sync, a `CardEntry` whose card isn't cached yet shows a placeholder, then resolves from Scryfall via `CardStore` (matches "downloaded directly from Scryfall on sync").
- Stats skip cards not yet cached; they catch up once card data is fetched (and after the Phase 4 price-refresh pass).

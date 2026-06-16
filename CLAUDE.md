# Card Hoard — App Store Plan

## Project Overview

SwiftUI iOS app for browsing and organizing Magic: The Gathering cards. Uses the Scryfall API for card/set data and SwiftData for local persistence. No user accounts; all data is on-device.

**Stack:** Swift, SwiftUI, SwiftData, Scryfall API  
**Tabs:** Home, Search, My Collection, Settings

---

## Goal

Ship Card Hoard to the App Store with quality-of-life upgrades, polished presentation, and monetization via in-app purchases (IAP).

---

# Git Workflow

**Always create a new branch before starting any phase or feature.**

- Branch from `appstore` (not `main`)
- Naming: `phase-1`, `phase-2`, `feature-filter-engine`, `feature-card-scanner`, etc.
- One branch per phase or self-contained feature
- Merge back to `appstore` when complete and verified on device
- Never commit directly to `appstore` or `main`

---

# Core Features

*Must ship for v1 App Store release.*

---

## Phase 1 — App Store Readiness

These are required or strongly recommended before submission.

### Legal & Compliance
- [ ] Add a Privacy Policy URL (required by Apple, even if no data is collected — host it on benmacintyre.net)
- [ ] Review Scryfall API terms of service — confirm commercial use is permitted
- [ ] Review Wizards of the Coast fan content policy — confirm App Store distribution is allowed
- [ ] Update disclaimer in-app (currently only in README) — add it to the Settings tab or an About screen

### App Identity
- [x] Bundle ID set: `net.benmacintyre.cardhoard`. Display name `Card Hoard` via `CFBundleDisplayName` (internal Xcode target/folder still named "MTG Collector" — not user-facing).
- [ ] Configure signing with your personal Apple Developer account
- [ ] Remove all "(School)" references from code comments and file headers
- [x] App name chosen: **Card Hoard** — avoids Wizards of the Coast trademarks (no "Magic"/"MTG"/"Gathering" in the name). Keep "mtg"/"magic gathering" in keywords only.

### App Store Connect Metadata
- [ ] Write App Store description (highlight: search, binders, decks, price data)
- [ ] Choose keywords (mtg, magic gathering, card collector, deck builder, binder, scryfall)
- [ ] Set age rating (likely 4+)
- [ ] Prepare screenshots for all required device sizes (6.9", 6.5", 5.5" at minimum)
- [ ] Create a short preview video (optional but helps conversion)

### Dark Mode & Widget Styling
- [x] Consolidated all widget styling into the single `widgetStyle()` `ViewModifier` (applied in ~19 places).
- [x] **Went straight to Liquid Glass** instead of the manual shadow/border approach below — since the app floor is iOS 26, `widgetStyle()` applies `.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 10))` unconditionally. Glass adapts to light/dark automatically, so the per-mode shadow/border/fill rules are no longer needed. (Completes the Phase 7 "Glass Rework" widget item too.)

~~Superseded by glass — kept for reference:~~
- ~~Background depth via `Color(.systemBackground)` / `Color(.secondarySystemBackground)`~~
- ~~Light-mode shadow `.gray.opacity(0.25) r6`; dark-mode glow `.gray.opacity(0.15) r8` + `strokeBorder`~~
- ~~Widget fill `Color(.secondarySystemBackground)`~~

### Code Cleanup
- [ ] Audit all `print()` statements — remove or replace with proper logging before release
- [ ] Handle the force-unwrap in `SFAPI.buildSearchURL` (`URL(string:)!` on line 37) — can crash if the query builds an invalid URL
- [ ] Add empty-state handling anywhere the API returns `[]`
- [ ] Test onboarding reset path (Settings → Delete Data should reset `onBoarding` flag too)

### Scryfall Rate Limiting
- [ ] Scryfall requests a max of 10 requests/second and a contact email in the `User-Agent` header — add `User-Agent: CardHoard/1.0 (contact@benmacintyre.net)` to all `URLSession` requests
- [ ] Home tab fires 6 simultaneous requests on load — stagger them with a small delay between each to stay well under the limit
- [ ] Deck import batches up to 75 cards per `/cards/collection` request — ensure parallel batches don't exceed rate limit
- [ ] Add a shared `SFAPIClient` that centralises all requests and can enforce rate limiting in one place rather than raw `URLSession` calls scattered across `SFAPI.swift`

### SwiftData Migration Plan
- [ ] Before shipping v1, define the initial schema as `SchemaV1` using SwiftData's `VersionedSchema`
- [ ] Every future data model change gets a new schema version (`SchemaV2`, `SchemaV3`, etc.) with a `SchemaMigrationPlan` that maps old data to new structure
- [ ] Without this, any model change after v1 ships will crash existing users on update and wipe their collection
- [ ] The Phase 2 data model rework IS the v1 schema — do not ship to the App Store before Phase 2 is complete or you'll need to migrate from the school version structure

---

## Phase 3 — Core Architecture

### Filter Engine

A single reusable `FilterSheet` UI with swappable engines injected by the calling view. The sheet looks identical everywhere; the engine determines what happens with the filter state.

**`FilterState` struct** — shared across all engines, holds all possible filter values:
```
text: String
colors: [String]
types: [String]
sets: [String]
rarities: [String]
cmcLower: Double
cmcUpper: Double
sortBy: String
sortDescending: Bool
formatLegality: String    // Scryfall only
isCommander: Bool         // Scryfall only
producedMana: [String]    // Scryfall only
foilOnly: Bool            // Collection only
favouritesOnly: Bool      // Collection only
```

**`FilterEngine` protocol:**
```swift
protocol FilterEngine {
    associatedtype Result
    func apply(filters: FilterState) async -> [Result]
}
```

**Two implementations:**
- `ScryfallFilterEngine` — reads `FilterState`, builds Scryfall query string, fires API, returns `[CardJSON]`
- `CollectionFilterEngine` — reads `FilterState`, builds SwiftData predicates + sort descriptors, returns `[CardEntry]`

**`FilterSheet`** — pure UI, binds to `FilterState`, knows nothing about the engine. Conditionally shows/hides options based on engine type (format legality hidden for collection engine; foil/favourites hidden for Scryfall engine).

**Usage:**
- Search tab → injects `ScryfallFilterEngine`
- Binder view → injects `CollectionFilterEngine`
- Deck view → injects `CollectionFilterEngine`
- General Collection → injects `CollectionFilterEngine`
- Adding a new filter context = new engine conformance, zero UI changes

---

## Phase 2 — Backend & Data Model Rework

This must happen before CloudKit sync is added, as CloudKit has constraints on SwiftData relationships that require structural changes. Do this whole phase together as one pass.

### New model hierarchy

**Add `Collection` base class:**

`Binder` and `Deck` share `id`, `name`, `notes`, `createdAt`, `editedAt`, `showPreviews`, `showControls`, `pinned`, `showCover`. Extract these into a `@Model class Collection` that both inherit from. Benefits:
- Eliminates duplicated properties
- Allows the My Collection tab to query `Collection` for a unified sorted list of both binders and decks
- Shared computed properties (e.g. `totalPrice`, `cardTypeCount`) can live on the base class where they apply to both

```
@Model class Collection       ← base: shared properties + isDeleted + sortBy
  @Model class Binder         ← adds coverImage, cards: [CardEntry]
  @Model class Deck           ← adds ruleType, commander, mainboard/sideboard/maybeboard
```

`sortBy` persists per collection so each binder/deck remembers its own sort independently. No global default needed in Settings — sort is set on first change and loaded from the model thereafter.

**Add `CardCache` — separate from synced data:**

Currently `CardEntry` holds a full `Card @Model` with all Scryfall data. If you add Lightning Bolt to 3 binders, you store 3 full copies of its data. Instead:

- `CardEntry` stores only `scryfallCardID: String` + your metadata (quantity, isFoil, favourite, dateAdded)
- A new `CardCache @Model` stores fetched card data keyed by Scryfall ID — **not synced to CloudKit**
- CloudKit only syncs the lightweight user data (binder structure, card IDs, quantities)
- Card details are re-fetched from Scryfall on demand and cached locally

```
CardEntry (synced)            ← scryfallCardID, quantity, isFoil, favourite, dateAdded
CardCache (local only)        ← full Card data, keyed by scryfallCardID, fetchedAt: Date
```

**Add `isDeleted: Bool` to synced models:**

CloudKit handles deletions better with a soft-delete flag. Add `isDeleted: Bool = false` to `Collection` (inherited by Binder/Deck) and `CardEntry`. Filter these out in all `@Query` calls.

### Fix nested `@Model` classes → value types

These classes are currently `@Model` but have no independent identity — they're just data containers nested inside `Card`. CloudKit struggles with deep relationship chains. Convert them to `Codable` structs stored directly on `Card`:

- `ImageURIs` → struct (used in both `Card` and `CardFace`)
- `Prices` → struct
- `PurchaseURIs` → struct
- `RelatedCardObject` → struct
- `CardFace` → struct (contains its own `ImageURIs`)

Once these are structs, the `SFAPI.JSONtoModel` function shrinks from ~90 lines to ~20 because the structs can map directly.

### Add missing Scryfall fields

**On `CardJSON` / `Card`:**
- [ ] `produced_mana: [String]` — what colors this card *produces* (different from `color_identity`); critical for mana base analysis, especially lands
- [ ] `edhrec_rank: Int` — EDHREC Commander popularity rank
- [ ] `set_name: String` — full set name (currently only storing the code e.g. `"dmu"`, not `"Dominaria United"`)
- [ ] `artist: String` — card artist
- [ ] `collector_number: String` — position within the set; identifies a specific printing
- [ ] `scryfall_uri: String` — link to Scryfall card page (**required by Scryfall API terms of service** when displaying their data)
- [ ] `rulings_uri: String` — API endpoint to fetch card rulings; needed for competitive/Commander play
- [ ] `related_uris: RelatedURIs` — links to EDHREC, Gatherer, TCGPlayer articles (new struct)

**On `PricesJSON` / `Prices`:**
- [ ] `eur: String` — Euro price (Cardmarket)
- [ ] `eur_foil: String` — Euro foil price
- [ ] `tix: String` — MTGO ticket price

**On `RelatedCardObjectJSON` / `RelatedCardObject`:**
- [ ] `component: String` — relationship type: `"token"`, `"meld_part"`, `"meld_result"`, `"combo_piece"`. Without this you can't tell what the related card's role is.

**On `CardFaceJSON` / `CardFace`:**
- [ ] `produced_mana: [String]` — double-faced lands produce mana on their back face; needed for accurate mana analysis
- [ ] `flavor_text: String` — flavor text per face (some DFCs have different flavor text per side)

### Collection Stats Model

Replace computed properties on `Binder` and `Deck` with a stored `CollectionStats` model linked by foreign key:

- [ ] Create `CollectionStats @Model` — stores all stat fields that currently live as computed properties
- [ ] Link to `Collection` via a one-to-one relationship (`collection.stats`)
- [ ] Stats are updated whenever cards are added, removed, or quantities changed — not computed on every read
- [ ] The front end filters the stats object depending on which collection is displayed (binder shows binder stats, deck shows deck stats for the selected board)
- [ ] Stats to store: `totalCards`, `uniqueCards`, `totalPriceUSD`, `totalPriceEUR`, `totalPriceTix`, `avgManaCost`, `landCount`, `highestPricedCardID`, `rarityBreakdown` (JSON/dict), `colourBreakdown` (JSON/dict), `typeBreakdown` (JSON/dict)
- [ ] `isLegal` stays computed on `Deck` — it's cheap and format legality data can change without card changes

### New struct to add

```
RelatedURIs {
    edhrec: String
    gatherer: String
    tcgplayerInfiniteDecks: String   // "tcgplayer_infinite_decks"
    tcgplayerInfiniteArticles: String // "tcgplayer_infinite_articles"
}
```

### CloudKit preparation

- [ ] Ensure all `@Relationship` arrays are optional-friendly (CloudKit requires relationships to handle nil)
- [ ] Replace any `@Attribute(.unique)` that uses non-UUID types — CloudKit handles UUID primary keys best
- [ ] Add `updatedAt: Date` to `Binder`, `Deck`, and `CardEntry` for sync conflict resolution
- [ ] Enable CloudKit capability in Xcode + add `cloudKitDatabase: .automatic` to modelContainer
- [ ] Test sync on a real device (simulator is unreliable for CloudKit)

---

## Phase 4 — Screen Reworks

### Home Tab
- [ ] Load each suggestion section independently so they appear as they finish rather than all-or-nothing
- [ ] Show a skeleton/placeholder row per section while it is fetching
- [ ] Cards load once per day — refresh on next day's first open, not on every launch (replace `isLoaded` bool with a stored `lastLoadedDate` and compare to today)
- [ ] Communicate the daily discovery concept in the UI — e.g. a subtitle under the header like "Your daily card discovery" so users understand the content is intentionally curated once per day
- [ ] Fix randomness — replace local `.shuffled()` with Scryfall's `order:random` sort parameter so cards are drawn from the full matching dataset, not just the first page of 175
  - Sections to update: New, Popular, Full Art, Old School
  - Pricey and Budget must keep price ordering — use a random `&page=N` offset instead so results vary while still being genuinely expensive/cheap

### Card Info View — Sheet Carousel

Replace the current full-screen navigation push with a **sheet carousel**:

- [ ] Present card info as a large sheet (near full screen) instead of a navigation push
- [ ] Inside the sheet, cards are in a horizontally paged carousel — each card page is slightly narrower than the screen so the edge of the next/previous card peeks in from the side
- [ ] Swiping left/right moves through the cards in whatever collection the card was opened from:
  - Opened from search results → swipe through search results
  - Opened from a binder → swipe through that binder's cards
  - Opened from a deck board → swipe through that board's cards
  - Opened from a Home suggestion row → swipe through that row's cards
- [ ] Scrolling down within a card expands the detail content (replaces the current layout where the card image sits in a fixed position)
- [ ] Every place that currently opens `CardInfoView` via `NavigationLink` needs to pass its surrounding card array + the starting index so the carousel knows its context
- [ ] Implementation: each call site passes `cards: [Card]` and `selectedIndex: Int` into the sheet; the sheet wraps them in a `TabView` with `.tabViewStyle(.page)` or `ScrollView(.horizontal)` with `.scrollTargetBehavior(.viewAligned)` (iOS 17+)

---

### My Collection Tab

**Redesign the main screen layout:**
- [x] Removed the "All Decks" link widget (`DecksLinkWidget`/`AllDecksLinkWidget` deleted) — replaced with two equal side-by-side buttons (**Binders** → new `AllBindersView`, **Decks** → `AllDecksView`)
- [x] Whole-collection stats widget at top (`WholeCollectionStatsWidget`) — total value, total cards, unique cards, colour breakdown; aggregates each collection's stored `CollectionStats`
- [x] **General Collection** section on the tab — a permanent catch-all `Binder` (`isGeneral == true`), auto-created on first launch, cards listed inline (not behind a link), excluded from `AllBindersView`

**Other fixes:**
- [x] Crash risk already resolved — `deleteBinder()` uses a safe `if let` (no `unsafelyUnwrapped` in the codebase)
- [x] Fixed double sort — binders/decks now use a single combined sort (pinned first, then `editedAt`) instead of a `@Query` sort plus a `ForEach` re-sort

---

### Search Tab

**Done in Phase 4:** Search migrated off the legacy `FilterSheet`/`CardFilters` onto the unified `FilterState` + `FilterSheetView` (`.scryfall` context) + `ScryfallFilterEngine` stack. Legacy `FilterSheet.swift`, `CardFilters.swift`, and the `fetchCardData`/`buildSearchURL`/`buildQuery` API path were deleted (one filter system now).

**Empty state:**
- [x] Show a proper "start searching" empty state on first open (magnifying glass + "Search for any Magic card"), distinct from the "No results found" state after a search

**Sets filter — fix lag:**
- [x] Replaced the `Menu`-based sets picker with a searchable sheet (`SetsFilterSheet`) — virtualised `List` + search bar, shows selected sets with a checkmark
- [x] Supports all set types (groups by raw `set_type`, so draft_innovation/promo/funny/token/etc. all appear)
- [x] Group sets by release year (default) or by type, toggled with a segmented control in the sheet

**Filter refinements:** (all live in `FilterSheetView`, now wired into Search)
- [x] CMC sliders have Min/Max labels and show a warning when min exceeds max; the query builder clamps an inverted range
- [x] Sort order filter (name, mana value, release date, USD price, EDHREC rank, colour, rarity) + descending toggle
- [x] Format legality filter (standard, modern, legacy, vintage, commander, pauper, pioneer)
- [x] `is:commander` filter option ("Can be Commander" toggle)
- [x] `produced_mana` filter (colour buttons → `produces:` query)

**Results:**
- [x] Result count shown above the grid ("N cards found")
- [x] Pagination via "Load More" button using Scryfall's `next_page`/`has_more` (175/page)

### Settings Tab

**Restructure into clear sections:**

- [ ] **Appearance** — theme/tint colour picker; card image quality toggle (normal vs large)
- [ ] **Currency** — global price currency selection: USD, EUR, MTGO tix; this setting must flow through to every price displayed in the app (binder totals, deck totals, card info, grid previews, stats)
- [ ] **iCloud Sync** — toggle sync on/off; display iCloud account status ("Connected" / "Sign in to iCloud in device Settings"); show last synced timestamp
- [ ] **Pro / IAP** — show Pro status (purchased / not purchased); Restore Purchases button (Apple requires this)
- [ ] **Collection Defaults** — default card preview visibility for newly created binders/decks
- [ ] **Data** — Delete collection data (fix: must also reset `onBoarding` flag); Clear card cache (for the new `CardCache` model)
- [ ] **Developer** — app version + build number; link to benmacintyre.net
- [ ] **Legal** — updated disclaimer (remove "school project" language); Privacy Policy link; Scryfall API attribution

**Expand the `Settings` model** (currently only `theme` and `onBoarding`):
- [ ] `currency: String` — `"usd"`, `"eur"`, `"tix"` (default `"usd"`)
- [ ] `cardImageQuality: String` — `"normal"` or `"large"` (default `"normal"`)
- [ ] `iCloudSyncEnabled: Bool` (default `true`)
- [ ] `defaultShowPreviews: Bool` (default `true`)
- [ ] `isPro: Bool` (default `false`) — set to `true` after IAP purchase verified

### Price Refresh for Collection Cards
- [ ] When a price widget comes on screen, check `CardCache.fetchedAt` for each card in view
- [ ] If the cached price is older than the defined interval (e.g. 24 hours), re-fetch that card's data from Scryfall and update the cache
- [ ] Only trigger on-screen visibility — use `onAppear` on the price widget, not on collection open, so cards never visible don't burn requests
- [ ] Batch re-fetches where possible using `/cards/collection` to avoid one request per card
- [ ] Update `CollectionStats` after prices refresh so totals stay current

### Collection Stats Rework
- [ ] Each collection type gets its own dedicated stats sheet with data relevant to that context:
  - **Binder stats:** total cards, unique cards, total value (in selected currency), value by rarity, colour breakdown, type breakdown, highest valued card, set breakdown
  - **Deck stats:** all of the above for mainboard + land count, average CMC, mana curve chart, legality status per format, commander legality, colour identity, sideboard value
  - **General Collection stats:** total cards, total value, rarity breakdown, colour breakdown — simpler than a full deck view
- [ ] Card rulings displayed within the card info sheet (fetched from `rulings_uri` on demand) — not part of stats but lives in the same area of the app

### Haptics
- [ ] Light tap (`UIImpactFeedbackGenerator(.light)`) when adding a card to any collection
- [ ] Medium tap when pinning/unpinning a binder or deck
- [ ] Heavy tap + success notification (`UINotificationFeedbackGenerator(.success)`) when deck import completes
- [ ] Error notification (`UINotificationFeedbackGenerator(.error)`) on scan failure or import failure
- [ ] Centralise into a `HapticManager` so haptic calls aren't scattered through views

### Onboarding
- [ ] Rework copy to be more descriptive — explain each tab's purpose clearly for a new user
- [ ] Improve art/visuals — replace placeholder graphics with polished illustration or card mockups

### Card Scanner
- [x] Scan button in the Search toolbar (`camera.viewfinder`)
- [x] Implemented with **VisionKit `DataScannerViewController`** (`CardScanner.swift`: `DataScannerView` + `CardScannerSheet`)
- [x] Flow: tap scan → live camera (`fullScreenCover`) → tap a highlighted name → fills the search bar → search fires
- [x] Confirm/edit: the scanned name lands in the editable search bar, so the user can fix OCR before re-searching
- [x] Separate from `CameraPicker.swift` (photo capture); added `NSCameraUsageDescription`
- [x] Gated on `DataScannerViewController.isSupported` — button hidden on unsupported devices (and the Simulator, which has no camera)

---

## Phase 5 — Deck Import Engine

Deck import is its own self-contained feature. Build it as a dedicated engine separate from the rest of the app.

### Text Parsing

- [ ] Support standard plain text format (used by Moxfield, Archidekt, TappedOut, MTGGoldfish, MTGO):
  ```
  4 Lightning Bolt
  4 Monastery Swiftspear

  Sideboard
  4 Smash to Smithereens

  Commander
  1 Atraxa, Praetors' Voice
  ```
- [ ] Support MTG Arena format with set code + collector number:
  ```
  4 Lightning Bolt (M21) 162
  ```
- [ ] Parse line by line: extract quantity (Int) + card name (String); strip set code/collector number if present
- [ ] Section headers (`Sideboard`, `Commander`, `Maybeboard`, `Deck`, `Main`) determine which board parsed cards below go into — case-insensitive
- [ ] Ignore blank lines and comment lines (lines starting with `//`)

### Card Resolution via Scryfall

- [ ] Use Scryfall's `/cards/collection` POST endpoint — accepts up to 75 card name identifiers per request, returns full card data in bulk
- [ ] Batch parsed card names into groups of 75 and fire in parallel
- [ ] Match results back to parsed lines by name; flag any cards Scryfall couldn't find
- [ ] Show a resolution preview before committing — list of matched cards and any unresolved names for the user to fix manually

### Import UI

- [ ] Entry point: button in the New Deck sheet or a dedicated import option in the Decks list
- [ ] Accept input via: paste text directly into a text field, or import a `.txt` file via the iOS Files picker (`fileImporter` modifier)
- [ ] Show a loading state while Scryfall resolves cards
- [ ] Show a review screen: matched cards grouped by board with quantities, unresolved cards listed separately
- [ ] User confirms → deck is created with all cards added to the correct boards
- [ ] Unresolved cards: allow user to search and manually match before confirming

### Import Engine Architecture

- [ ] `DeckImportParser` — pure struct, no SwiftUI; takes raw string, returns parsed lines with quantity/name/board
- [ ] `DeckImportResolver` — async, takes parsed lines, batches Scryfall requests, returns resolved + unresolved results
- [ ] `DeckImportViewModel` — drives the import UI, owns parser + resolver
- [ ] Keep parser and resolver completely decoupled from SwiftData so they can be unit tested independently

## Phase 6 — In-App Purchases & Paywall

### Free Tier
- Search + card info (Scryfall data must never be paywalled per TOS)
- Home discovery tab
- General Collection (unlimited cards)
- Up to 3 binders + 3 decks (basic view, no stats)
- Card scanner (5 scans/day)

### Pro Tier — one-time purchase ($1.99–$2.99)
- Unlimited binders and decks
- Detailed binder stats sheet
- Detailed deck stats sheet (mana curve, legality, type breakdown)
- iCloud sync via CloudKit
- Unlimited card scanning
- Deck import engine
- CSV export

### Implementation
- [ ] Use **StoreKit 2** (`Product`, `Transaction`) — not legacy StoreKit 1
- [ ] Add **Restore Purchases** button in Settings → Pro section (Apple requires this)
- [ ] Gate Pro features with a shared `ProAccessManager` that checks `isPro` from `Settings` model — one place to check, not scattered through views
- [ ] Set `settings.isPro = true` after StoreKit transaction verified
- [ ] CloudKit sync itself is free — IAP gates it as a convenience unlock, not infrastructure cost

---

## Phase 7 — Front End Polish

**Do this last — after all backend, data model, and CloudKit work is complete.**

The front end should not be heavily polished until the data layer is stable.

---

# Extended Features

*Ship after v1. These are v2+ updates that add depth and differentiation.*

---

## Extended Phase 1 — Deck Suggestion Engine

See **[SuggestionModelPlan.md](SuggestionModelPlan.md)** for full details.

A fully on-device deck suggestion engine using a Create ML trained tabular model + Scryfall queries. No API costs, no subscription needed, works offline.

**How it works:**
1. Calculate deck stats from `CollectionStats`
2. Feed stats into a Core ML model → outputs weakness flags (needs lands, needs removal, curve too high, etc.)
3. For each weakness, fire a targeted Scryfall query to find cards that fix it, filtered by colour identity + format + EDHREC rank
4. Present suggestions with a plain-English reason per suggestion

**This is a Pro feature** — the "seller" feature that differentiates the app.

---

## Extended Phase 2 — External Resources Engine

A centralised manager + reusable widget for linking out to external sites. One `ExternalResourcesWidget` used across the app; the calling screen feeds it context so it surfaces the right links.

### `ExternalResourcesManager`
Holds all known resource types and their URLs. Sources links from:
- Fields already fetched from Scryfall: `scryfall_uri`, `rulings_uri`, `related_uris` (EDHREC, Gatherer, TCGPlayer Infinite), `purchase_uris` (TCGPlayer, Cardmarket, CardHoarder)
- Hardcoded URL templates for resources not in Scryfall data (e.g. MTGGoldfish)

### `ExternalResourcesContext` enum
The calling screen passes a context value that determines which resources are relevant:

| Context | Resources Shown |
|---|---|
| `.card` | Scryfall page, EDHREC, Gatherer, Rulings, TCGPlayer, Cardmarket, CardHoarder |
| `.deck` | EDHREC deck search, MTGGoldfish meta, Moxfield |
| `.binder` | TCGPlayer collection value, Cardmarket |
| `.commander` | EDHREC commander page (uses commander card's EDHREC link) |

### `ExternalResourcesWidget`
- Reusable view, takes `ExternalResourcesManager` + `ExternalResourcesContext`
- Displayed as a section within a sheet (card info sheet, deck stats sheet, etc.)
- Each resource shown as a labelled row with site icon — taps open in the in-app `WebSheet`
- Only shows resources where a URL is actually available (skips missing fields gracefully)

---

## Extended Phase 3 — Additional Features

### Quickness Layer — Spotlight & Shortcuts
- [ ] **Spotlight Search** — `Spotlight.swift` exists already; wire it up using `CSSearchableItem` so saved cards, binders, and decks appear in iOS Search and can be opened directly
- [ ] **App Intents / Siri Shortcuts** — expose key actions via the `AppIntents` framework (iOS 16+, already met by SwiftData requirement); useful intents:
  - "Search for [card name]" — opens Search tab with query pre-filled
  - "Open [binder name]" — jumps directly to a binder
  - "Scan a card" — launches the card scanner directly
  - "Show my collection value" — surfaces total value via Siri or Lock Screen
- [ ] Spotlight and AppIntents share the same indexing work — implement together
- [ ] AppIntents also powers the Action button on iPhone 15 Pro+ — worth noting as a bonus

### Share & Export
- [ ] **Share sheet** — share a card image or deck list via the iOS share sheet
- [ ] **CSV / text export** — export a binder or deck as plain text (Name, Set, Quantity) compatible with Moxfield, Archidekt, etc.

### Collection Types
- [ ] **Wishlist binder** — special binder mode marking cards as "wanted" rather than "owned"; shows total wishlist value

---

### Phase 7 — Front End Polish (continued)

This phase covers:
- [ ] Full UI/UX pass on all screens — spacing, typography, colour usage, component consistency
- [ ] Animations and transitions — card additions, sheet presentations, stat updates
- [ ] Empty states for every screen (no collection, no search results, no cards in binder, etc.)
- [ ] Loading skeletons wherever async data is fetched
- [ ] Accessibility — Dynamic Type support, VoiceOver labels on custom controls
- [ ] App icon and launch screen polish
- [ ] Any remaining screen-specific changes identified during planning (see Phase 4)

### Glass Rework (iOS 26+)

**Minimum iOS target is 26.0** — set as the deployment floor because the Phase 2 data model relies on SwiftData `@Model` class inheritance (`Binder`/`Deck` inherit from `Collection`), which is iOS 26-only. This means glass is available everywhere with no fallback path needed.

- [ ] System components (tab bar, navigation bar, sheets) automatically adopt Liquid Glass on iOS 26 — no code needed
- [ ] Custom widgets opt in via `.glassEffect()` modifier — apply unconditionally, no `if #available` gate required since the app floor is iOS 26
- [x] Update `widgetStyle()` ViewModifier to apply `.glassEffect()` directly; the iOS 17–25 shadow fallback is no longer needed — done early (Card Hoard widgets are all glass)

---

## Phase 8 — Post-Launch

- [ ] Monitor App Store reviews and crash reports via Xcode Organizer
- [ ] Add TestFlight beta for friends/testers before wide release
- [ ] Update Scryfall set data periodically (new sets release ~every 3 months)

---

## Notes

- Scryfall API is free and does not require an API key. Keep it that way — no key to manage or expose.
- **CloudKit is the sync strategy** — iOS-only app, so no need for Supabase (which is for cross-platform). CloudKit is free and uses the user's Apple ID. Supabase is reserved for the Flutter app project.
- SwiftData + CloudKit requires testing on a real device with iCloud signed in — the simulator does not reliably test sync.
- The `Settings` model only has `theme` and `onBoarding` — any new user preferences go here.
- IAP should use **StoreKit 2** (`Product`, `Transaction`) not the legacy StoreKit 1 API.

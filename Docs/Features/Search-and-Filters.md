# Search & Filters

## Summary

The Search tab queries Scryfall's full database and renders results in a card grid with a "N cards
found" count and "Load More" pagination. Filtering uses a single reusable `FilterSheetView` bound to
a shared `FilterState`, with a swappable **engine** injected by the caller: `ScryfallFilterEngine`
builds a Scryfall query string, while `CollectionFilterEngine` builds SwiftData predicates for
binders/decks/My Hold. The sheet hides options that don't apply to the active context. A dedicated,
searchable Sets picker replaces the old laggy menu, and a camera scan button launches the live card
scanner.

## Capabilities

- Full-text Scryfall search with empty-state ("start searching") vs no-results states.
- One filter UI, two engines (Scryfall API vs local collection) chosen by `FilterContext`.
- Filters: colours, types, sets, rarities, CMC range (with inverted-range clamp), sort + direction,
  format legality, `is:commander`, `produced_mana`; plus foil/favourites for collections.
- Searchable Sets sheet grouped by year or type, supporting all set types.
- Result count + "Load More" pagination via Scryfall `next_page` / `has_more`.
- Toolbar scan button → live card-name scanner (see [Card Scanner](Card-Scanner.md)).

## Code map

| Piece | Location |
|---|---|
| Search tab (query, pagination, empty states, scan button) | `MTG Collector/Search/SearchTabView.swift:23` |
| Shared filter state + sort options | `MTG Collector/Data/Filters/FilterState.swift:51` (`FilterSort` `:19`) |
| Filter UI + context gating | `MTG Collector/Search/Sheets/FilterSheetView.swift:30` (`FilterContext` `:24`) |
| Filter engine protocol + both engines | `MTG Collector/Data/Filters/FilterEngine.swift` (`ScryfallFilterEngine:29`, `CollectionFilterEngine:45`) |
| Searchable sets picker | `MTG Collector/Search/Widgets/SetsFilterWidget.swift:57` (`SetsFilterSheet`) |
| Scryfall API client | `MTG Collector/Data/SFAPI.swift:19` |
| Result card cell | `MTG Collector/Search/Views/SearchCardView.swift` |

## Notes

- The legacy `FilterSheet`/`CardFilters`/`buildSearchURL` path was deleted — there is one filter
  system. Adding a new filter context = a new `FilterEngine` conformance, zero UI changes.

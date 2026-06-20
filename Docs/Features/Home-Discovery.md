# Home & Discovery

## Summary

The Home tab is a **daily card-discovery feed**. Each themed row (New, Popular, Pricey, Budget, Full
Art, Old School) fetches up to 25 cards from Scryfall and shows the first 8 with a "View All" tile
into the full list. The whole set is chosen once per day from a date-seeded RNG (so it's stable
through the day and re-rolls at the daily reset) and cached to disk, so cold launches don't refetch.
Rows load independently with skeleton placeholders, and an MTG news row is mixed in. A "Refreshes in
Xh" countdown shows when the set rolls over.

## Capabilities

- 6 themed rows, each a Scryfall query with daily variety (random page jump for ranked rows).
- Per-row independent loading with shimmer skeletons.
- Once-per-day caching keyed on the calendar day; dev reload token forces a refetch.
- 8-card preview strip + ghost "View All" tile → full 25-card list with a refresh countdown.
- MTG news row (MTGGoldfish / Wizards / r/magicTCG RSS) opening articles in an in-app web sheet.

## Code map

| Piece | Location |
|---|---|
| Home tab view, row loading (`loadSuggestions`, `prefix(25)`) | `MTG Collector/Home/HomeTabView.swift:21` |
| Row definitions (title, icon, blurb, query, daily page jump) | `MTG Collector/Home/HomeSection.swift:20` |
| Feed composition + daily seed + `SeededGenerator` | `MTG Collector/Home/HomeFeed.swift:79` (build `:89`) |
| Daily cache (load/save, freshness, refresh countdown) | `MTG Collector/Data/HomeSuggestionsStore.swift:21` (`refreshCountdownText` `:45`) |
| Cached blob model | `MTG Collector/Data/Models/HomeSuggestions.swift` |
| One suggestion row (8 previews + ghost View-All tile + footer) | `MTG Collector/Home/Widgets/SuggestionWidget.swift:19` |
| Full themed list + "Refreshes in Xh" footer | `MTG Collector/Home/Views/SuggestionView.swift:17` |
| News row | `MTG Collector/Home/Widgets/NewsFeedWidget.swift` |
| Collection-preview + quick-link rows | `MTG Collector/Home/Widgets/CollectionPreviewWidget.swift:21`, `QuickLink` in `HomeFeed.swift:22` |

## Notes

- Fetching 25/row (was 10) keeps the cache + image prefetch far below a full 175-card Scryfall page.
- The reload/shuffle control was removed; rows refresh only on the daily roll-over (or dev reload).

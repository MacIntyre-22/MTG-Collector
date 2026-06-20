# Collection Stats

## Summary

Each collection's statistics (total/unique cards, total value per currency, rarity/colour/type
breakdowns, average mana cost, land count, highest-valued card) are **stored** in a `CollectionStats`
`@Model` rather than recomputed on every read. Stats are updated whenever cards change, and after a
price refresh or a CloudKit sync import. Dedicated stats sheets present the relevant slice per
context — binder, deck (with mana curve, legality, board totals), and whole-collection.

## Capabilities

- Stored stats keyed to a collection; updated on add/remove/quantity-change.
- Whole-collection summary widget aggregates only `inCollection` collections.
- Binder stats, deck stats (mana curve, legality, board totals, colour identity), and a simpler
  whole-collection stats sheet.
- Stats are local-only (not synced) and rebuilt on the receiving device after a sync import.

## Code map

| Piece | Location |
|---|---|
| Stored stats model | `MTG Collector/Data/Models/CollectionStats.swift:23` |
| Stats store (fetch/ensure/remove) | `MTG Collector/Data/StatsStore.swift:23` (`ensure:41`) |
| Stats updater (recompute on change) | `MTG Collector/Data/StatsUpdater.swift:22` |
| Whole-collection summary widget | `MTG Collector/MyCollection/Widgets/WholeCollectionStatsWidget.swift:22` |
| Whole-collection stats sheet + aggregator | `MTG Collector/MyCollection/Sheets/WholeCollectionStatsSheet.swift:21` (`StatsAggregator:53`) |
| Binder stats sheet | `MTG Collector/MyCollection/Sheets/BinderStatsSheet.swift:21` |
| Deck stats sheet | `MTG Collector/MyCollection/Sheets/DeckStatsSheet.swift:25` |
| Shared stats content + breakdown/legality/curve widgets | `MTG Collector/MyCollection/Sheets/CollectionStatsContent.swift:23`, `MTG Collector/MyCollection/Widgets/` (`BreakdownListWidget`, `LegalWidget`, `ManaCurveWidget`, …) |

## Notes

- Detailed stats sheets are a Pro feature (basic collection view is free). See [Pro & IAP](Pro-IAP.md).
- Breakdown rows and the legality tile carry optional `InfoDetail` beginner explainers.

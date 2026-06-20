# Deck Import

## Summary

A self-contained engine that turns a pasted or imported decklist (Moxfield / Archidekt / TappedOut /
MTGGoldfish / MTGO / MTG Arena formats) into a deck. The parser extracts quantity + name + board from
each line (handling section headers, set codes/collector numbers, comments, blank lines); the
resolver batches names to Scryfall's `/cards/collection` endpoint (75/request, parallel) and reports
matched vs unresolved cards. A review screen lets the user fix unresolved names before committing.
Parser and resolver are decoupled from SwiftData so they're unit-testable.

## Capabilities

- Plain-text + MTG Arena (set code + collector number) formats; section headers route to boards.
- Ignores comments (`//`) and blank lines; strips set/collector suffixes.
- Bulk resolution (75/request, parallel) with matched/unresolved reporting.
- Review screen with manual match for unresolved cards.
- **Heavy + success haptic** on completion; **error haptic** on an unreadable file.

## Code map

| Piece | Location |
|---|---|
| Parser (pure, no SwiftUI) — boards, lines | `MTG Collector/Data/DeckImport/DeckImportParser.swift:51` (`DeckBoard:20`, `ParsedDeckLine:28`) |
| Resolver (Scryfall batches) | `MTG Collector/Data/DeckImport/DeckImportResolver.swift` (`ResolvedDeckCard:21`, `DeckImportResult:28`) |
| Import view model | `MTG Collector/Data/DeckImport/DeckImportViewModel.swift:25` |
| Import sheet (paste / file picker, success+error haptics) | `MTG Collector/MyCollection/Sheets/ImportCardsSheet.swift:32` (`ImportTarget:23`) |
| Review screen + unresolved match sheet | `MTG Collector/MyCollection/Sheets/DeckImportReviewView.swift:21` (`UnresolvedMatchSheet:138`) |
| New-deck entry point (import text) | `MTG Collector/MyCollection/Sheets/NewDeckSheet.swift:22` |

## Notes

- Deck import is a Pro feature. Also reachable from a `.txt`/`.csv` opened via the iOS Files picker
  (routed through `MTG_TabView`'s import chooser).

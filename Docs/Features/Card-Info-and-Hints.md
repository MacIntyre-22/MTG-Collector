# Card Info & Hints

## Summary

Tapping a card opens a detail screen with the art (long-press for full-screen), a details panel
(name with inline layout/Alchemy glyphs, type line, mana cost, traits, keywords, oracle text rendered
with inline mana symbols), rulings fetched on demand, format legalities, related cards, prices in the
selected currency, and external resource links. A reusable **info system** (`InfoDetail` →
`InfoSheet` → `InfoPill`) powers tap-to-learn explainers for keywords, card traits, deck roles and
formats, gated by a "Beginner Hints" setting so the UI stays clean for experts.

## Capabilities

- Card detail view with flippable faces and split/adventure/aftermath/flip handling.
- Oracle text + mana costs rendered with inline Scryfall symbol SVGs.
- Card-name parser with inline icons (Alchemy "A-" → flask; " // " → layout glyph).
- Rulings fetched on demand from `rulings_uri`.
- Generic, data-driven info sheets (one sheet, many sources) for beginner explainers.
- Glossaries: 363 keywords, card traits, formats, deck roles — all JSON-backed.

## Code map

| Piece | Location |
|---|---|
| Card detail screen | `MTG Collector/SharedViews/CardInfoView.swift:21` |
| Details panel (header, traits, keywords, oracle, prices) | `MTG Collector/SharedViews/Widgets/InfoDisplayWidget.swift:24` |
| Card image + full-screen long-press (+ a11y label) | `MTG Collector/SharedViews/CardImageView.swift:17` |
| Oracle/mana inline symbol rendering | `MTG Collector/SharedViews/Widgets/OracleTextView.swift:231` (`ManaCostView:199`) |
| Generic info system (`InfoDetail`, `InfoPill`, `InfoSheet`, `\.beginnerHints`) | `MTG Collector/SharedViews/Widgets/InfoDetail.swift:42` |
| Keyword glossary (363 entries) | `MTG Collector/Data/KeywordGlossary.swift:20` + `KeywordGlossary.json` |
| Card traits (Alchemy, reserved, DFC, split, saga…) | `MTG Collector/Data/CardTraits.swift:21` + `CardTraits.json` |
| Format glossary | `MTG Collector/Data/FormatGlossary.swift:20` + `FormatGlossary.json` |
| Card model + value-type sub-structs | `MTG Collector/Data/Models/Card.swift:17` |
| Add-to-collection control | `MTG Collector/SharedViews/Widgets/CollectionControllWidget.swift:18` |

## Notes

- The card model's nested types (`ImageURIs`, `Prices`, `CardFace`, `PurchaseURIs`, `RelatedURIs`,
  `RelatedCardObject`) are Codable **structs** on `Card`, not `@Model` classes — kept CloudKit-legal.
- Beginner Hints toggle (default on) → `\.beginnerHints` environment; injected at the tab root.

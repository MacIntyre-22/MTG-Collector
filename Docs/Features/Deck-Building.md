# Deck Building

## Summary

Decks carry a **rule type** (format) that drives their structure: a leader slot system (commander /
oathbreaker / etc.) generalised by rule type, three boards (main / side / maybe), automatic colour
identity, and per-format legality checks. Leaders are flagged mainboard cards shown in their own
widget; each board shows a card grid with a legality-issue summary and filtering. Colour identity is
computed from the deck's cards (with a manual override option).

## Capabilities

- Rule-type-driven leader slots (roles carried through sharing/import).
- Main/side/maybe boards via one reusable `DeckBoardView` with per-board counts + issue summary.
- Automatic colour identity from cards, with manual override.
- Per-format legality status per card and overall deck legality.
- Empty states per board (empty vs filter-hidden).

## Code map

| Piece | Location |
|---|---|
| Deck model (boards, leaders, rule type, colour identity) | `MTG Collector/Data/Models/Deck.swift:23` |
| Rule types + leader slots | `MTG Collector/Data/DeckRules.swift:33` (`DeckLeaderSlot:20`) |
| Deck roles (ramp/draw/removal/tutor) + classifier | `MTG Collector/Data/DeckRoles.swift` (`DeckRoleDefinition:23`, `DeckRoleClassifier:60`) + `DeckRoles.json` |
| Auto colour identity | `MTG Collector/Data/DeckColors.swift:24` (`refresh:31`) |
| Deck detail view (boards, commander, toolbar) | `MTG Collector/MyCollection/Views/DeckView.swift:20` |
| One board (grid, legality summary, filter, empty states) | `MTG Collector/MyCollection/Views/DeckBoardView.swift:52` (`DeckBoardKind:21`) |
| Leader/commander widget | `MTG Collector/MyCollection/Widgets/CommanderWidget.swift:20` |
| Deck card cell | `MTG Collector/MyCollection/Views/DeckCardView.swift:19` |
| New / edit deck sheets | `MTG Collector/MyCollection/Sheets/NewDeckSheet.swift:22`, `EditDeckSheet.swift:18` |

## Notes

- `isLegal` stays computed on `Deck` (cheap; format data can change without card changes).
- Leaders are mainboard cards with a non-empty `role`, filtered out of the main grid.

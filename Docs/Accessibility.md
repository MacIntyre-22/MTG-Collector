# Accessibility

Reference for the App Store **accessibility** information and for ongoing accessibility work.

## Summary

Cardhold is a SwiftUI app on an iOS 26 floor, so it inherits the platform's accessibility stack:
Dynamic Type, VoiceOver, Bold Text, Increase Contrast, and Reduce Transparency all work through
standard SwiftUI controls and system materials (Liquid Glass). On top of that, custom controls have
been given explicit VoiceOver labels, and the brand/display type scales with Dynamic Type.

## Supported accessibility features

| Feature | Status | Notes |
|---|---|---|
| **VoiceOver** | Supported | System controls are labelled automatically; custom controls have explicit labels (see Code map). |
| **Dynamic Type** | Supported | System text styles throughout; the custom "Cardhold" wordmark uses `relativeTo:` so it scales too. |
| **Bold Text** | Supported (system) | Standard fonts honour the system Bold Text setting. |
| **Increase Contrast / Reduce Transparency** | Supported (system) | Liquid Glass + system materials adapt automatically. |
| **Larger Text / layout reflow** | Supported | Lists, forms and stacks reflow; sheets size to content (`.presentationDetents([.height(…)])`). |
| **Dark Mode** | Supported | Glass and `Color(.systemBackground)` adapt; theme accent colour is user-selectable. |
| **Reduced Motion** | Supported | Decorative loops (gradient drift, crown/button shine, onboarding badge float) are gated on `@Environment(\.accessibilityReduceMotion)`. |

## Custom VoiceOver labels (added explicitly)

- **Card art** — labelled with the card name + hint "Press and hold to view full screen".
  `MTG Collector/SharedViews/CardImageView.swift:65`
- **Price pills** — read as e.g. "Foil price $12.50" / "Regular price $1.50" instead of a bare number.
  `MTG Collector/SharedViews/Widgets/GridPriceWidget.swift:55`
- **Rarity pills** — read as e.g. "Rare rarity".
  `MTG Collector/SharedViews/Widgets/GridRarityWidget.swift:56`
- **Toolbar icon menus** — ellipsis menus labelled "More"; the active-filter icon labelled "Filter"
  (Binder / Deck / My Hold):
  `MTG Collector/MyCollection/Views/BinderView.swift`,
  `MTG Collector/MyCollection/Views/DeckView.swift`,
  `MTG Collector/MyCollection/MyCollectionTabView.swift`

## Dynamic Type for the brand font

The Erben Gothic "Cardhold" wordmark is requested with a relative text style so it scales:
`Font.custom(postScriptName, size:, relativeTo:)` — `MTG Collector/SharedViews/BrandFont.swift:33`.

## Beginner Hints (cognitive accessibility)

A built-in "Beginner Hints" layer adds tap-to-learn explanations for MTG-specific concepts (keywords,
card traits, deck roles, format legality) so newcomers aren't lost.
- Environment flag: `\.beginnerHints` — `MTG Collector/SharedViews/Widgets/InfoDetail.swift`
- See [Card Info & Hints](Features/Card-Info-and-Hints.md).

## Known gaps / future work

- **VoiceOver audit**: a full pass over every custom widget (stats charts, mana curve, holo pills on
  card tiles) to confirm grouping and reading order.
- **Colour as sole signal**: legality/rarity also carry text labels, but a contrast review against
  the user-selectable accent colour is advisable.

## Suggested App Store "Accessibility Nutrition" answers

- VoiceOver: **Supported**
- Voice Control: Supported (standard controls)
- Larger Text (Dynamic Type): **Supported**
- Bold Text: **Supported**
- Reduced Motion: **Supported**
- Sufficient Contrast: Supported (system materials; verify with chosen accent)
- Dark Interface: **Supported**
- Differentiate Without Color Alone: **Supported** (rarity/legality carry text)

# Design System

## Summary

Cardhold's look is built on iOS 26 **Liquid Glass**, a user-selectable accent colour, the **Erben
Gothic** "Cardhold" wordmark, and a small set of reusable animations and haptics. Glass treatments
are defined once in `AppGlass` and applied by name via `widgetStyle()` / `pillStyle()`. The accent
tint flows through an `\.appTint` environment value (default app-icon blue). Brand wordmark, ambient
gradient background, and a reusable capsule "shine" give the premium surfaces (launch, onboarding,
Pro) a consistent identity. Haptics are centralised in one manager.

## Capabilities

- Named Liquid Glass treatments (`solid` / `translucent` / `tinted`) applied via modifiers.
- User-selectable accent colour (hex) propagated via `\.appTint`; default `#007AFF` (icon blue).
- Erben Gothic "Cardhold" wordmark (CoreText-registered at launch, Dynamic-Type aware).
- Reusable ambient gradient background + capsule shine; crown shine on the paywall.
- Centralised haptics (light/medium/heavy/success/error), incl. long-press-to-fullscreen + scan/import errors.

## Code map

| Piece | Location |
|---|---|
| Glass palette + `widgetStyle()` / `pillStyle()` | `MTG Collector/SharedViews/Modifiers/WidgetStyle.swift:21` (`widgetStyle:46`, `pillStyle:51`) |
| Accent tint environment + hex colour | `MTG Collector/Data/Color+Hex.swift` (`\.appTint`) |
| Brand wordmark font (register + `wordmark`) | `MTG Collector/SharedViews/BrandFont.swift:19` (`register:26`, `wordmark:33`) |
| Font file | `MTG Collector/Fonts/Erben Gothic/erben_gothic.ttf` (PostScript `ErbenGothic-Regular`) |
| Animated gradient background | `MTG Collector/SharedViews/AnimatedTintBackground.swift:18` |
| Reusable capsule shine modifier | `MTG Collector/SharedViews/CapsuleShine.swift:17` (`.capsuleShine()`) |
| Crown shine | `MTG Collector/Settings/PaywallView.swift` (`shiningCrown`) |
| Haptics manager | `MTG Collector/Data/HapticManager.swift:16` |
| Launch splash (icon + wordmark + gradient) | `MTG Collector/SharedViews/LaunchGate.swift` |

## Where the brand wordmark appears

Home header, launch splash, onboarding welcome title, Pro sheet title — all via `BrandFont.wordmark`.
("My Hold" intentionally uses the system font.)

## Haptic touchpoints

| Action | Haptic |
|---|---|
| Add card to a collection | light |
| Pin/unpin binder or deck | medium |
| Long-press a card → full screen | medium |
| Deck import complete | heavy + success |
| New binder/deck created, file import committed | success |
| Scan no-match / unreadable import file | error |

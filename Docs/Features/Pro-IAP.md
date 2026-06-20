# Pro & IAP

## Summary

Pro is sold via **StoreKit 2** (monthly/annual subscriptions) and unlocks the app's value-add
features. A single `ProAccessManager` is the one place that resolves entitlement; views check
`pro.isPro` and present the paywall when gated. The verified entitlement is mirrored into the
`Settings` model and `UserDefaults` so offline gating and the CloudKit container both see it. The
paywall lists features, offers the subscriptions, and includes the Apple-required **Restore
Purchases** button.

## Free vs Pro

- **Free:** Search + full Card Info (Scryfall data never paywalled), Home discovery, unlimited My
  Hold, up to 3 binders + 3 decks (basic view), limited daily card scans.
- **Pro:** unlimited binders/decks, detailed binder & deck stats, iCloud sync, deck & collection
  import/export, sharing, unlimited scanning.

## Code map

| Piece | Location |
|---|---|
| Entitlement manager (StoreKit 2, products, purchase, restore, dev unlock) | `MTG Collector/Data/ProAccessManager.swift:24` |
| Paywall (features, subscriptions, restore, shining crown) | `MTG Collector/Settings/PaywallView.swift:21` |
| Entitlement mirror → Settings + UserDefaults | `MTG Collector/MTG_TabView.swift` (`onChange(of: pro.isPro)`) |
| Sync gating reads `isProEntitled` | `MTG Collector/Data/AppModelContainer.swift:56` |
| Free-tier limits (binders/decks count, scans) | `AllBindersView.swift:34`, `AllDecksView.swift:36`, `MTG Collector/Data/ScanLimit.swift:19` |
| Settings Pro section + Restore | `MTG Collector/Settings/SettingsTabView.swift` (`proSection`) |

## Notes

- The crown on the paywall has a polished diagonal shine; the Explore-Pro button in onboarding uses
  the reusable `capsuleShine()`. See [Design System](Design-System.md).
- Restore Purchases is present in both the paywall and Settings (Apple requirement).

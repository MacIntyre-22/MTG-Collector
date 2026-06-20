# Cardhold — Feature Documentation

Per-feature reference for Cardhold (Xcode target internally named "MTG Collector"). Each feature
doc opens with a plain-English **summary**, then a **Code map** with file paths and line numbers for
the key types and entry points.

> Line numbers reflect the state of the code when written and may drift as files change. Treat them
> as anchors — search for the named symbol if a number is off.

**Stack:** Swift · SwiftUI · SwiftData (iOS 26 floor, `@Model` class inheritance) · Scryfall API ·
CloudKit · StoreKit 2.

## Features

| Doc | Covers |
|---|---|
| [Home & Discovery](Features/Home-Discovery.md) | Daily card discovery feed + MTG news |
| [Search & Filters](Features/Search-and-Filters.md) | Scryfall search, unified filter engine, sets picker |
| [Card Scanner](Features/Card-Scanner.md) | Live VisionKit card-name scanner |
| [Card Info & Hints](Features/Card-Info-and-Hints.md) | Card detail view, oracle text, rulings, beginner-hint info system |
| [Collections & Data Model](Features/Collections-and-Data-Model.md) | Binders, Decks, My Hold + the SwiftData model hierarchy |
| [Collection Stats](Features/Collection-Stats.md) | Stored stats model, store/updater, stats sheets |
| [Deck Building](Features/Deck-Building.md) | Leaders, boards, colour identity, format legality |
| [Deck Import](Features/Deck-Import.md) | Text/file decklist import engine |
| [Sharing & Export](Features/Sharing-and-Export.md) | CloudKit snapshot links, CSV/TXT export & import |
| [Pro & IAP](Features/Pro-IAP.md) | StoreKit 2, paywall, feature gating |
| [iCloud Sync](Features/iCloud-Sync.md) | Two-store CloudKit container, sync status |
| [Price Refresh & Cache](Features/Price-Refresh-and-Cache.md) | On-open stale-price refresh, card cache |
| [Onboarding & Tab Guides](Features/Onboarding-and-Tab-Guides.md) | First-run flow + per-tab intros |
| [Design System](Features/Design-System.md) | Brand font, Liquid Glass, animations, haptics |
| [Quick Access](Features/Quick-Access.md) | Spotlight indexing + App Intents / Siri |

## App Store reference

| Doc | Covers |
|---|---|
| [Accessibility](Accessibility.md) | VoiceOver, Dynamic Type, motion, contrast — for the App Store accessibility nutrition info |
| [App Store Compliance](AppStore-Compliance.md) | Scryfall API terms, WotC Fan Content Policy, privacy policy, data collection |

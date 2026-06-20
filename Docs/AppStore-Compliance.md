# App Store Compliance

Notes for App Store submission: third-party terms, fan-content policy, privacy, and data collection.
**This is a developer reference, not legal advice.** Last reviewed: June 2026.

## 1. Privacy Policy

- **In-app link:** `https://cardhold.ca/privacy`
  (`MTG Collector/Settings/SettingsTabView.swift` → `privacyURL`, in the Legal section).
- **Verification:** an automated fetch of that URL returned **HTTP 403** (the host blocks
  non-browser requests), so the page content could **not** be confirmed programmatically. **Action:
  open it in a real browser to confirm it loads and reads as a privacy policy.** Apple requires a
  reachable Privacy Policy URL in App Store Connect.
- **What the policy should state** (matches the app's behaviour): no account; all collection data is
  stored on-device with SwiftData; optional iCloud sync stores data in the user's **private** CloudKit
  database (not accessible to the developer); card data/images are fetched from Scryfall; no analytics
  or third-party trackers; a contact email.

## 2. Data collection (for the App Privacy "nutrition label")

- **No developer-collected data.** There are no accounts, no analytics SDKs, no ad SDKs.
- Collection data (binders, decks, card IDs, quantities) lives on-device; with Pro + sync enabled it
  syncs to the user's **private iCloud** via CloudKit — Apple-managed, not collected by the developer.
  See [iCloud Sync](Features/iCloud-Sync.md).
- Network requests go to Scryfall (card data/images/prices) and a few news RSS feeds; no personal
  data is sent. Requests carry a descriptive User-Agent only (`MTG Collector/Data/AppHTTP.swift:19`).
- Suggested App Privacy answer: **"Data Not Collected."**

## 3. Scryfall API terms

Source: [Scryfall API docs](https://scryfall.com/docs/api),
[Rate limits](https://scryfall.com/docs/api/rate-limits),
[User-Agent/Accept required](https://scryfall.com/blog/user-agent-and-accept-header-now-required-on-the-api-225).

Key rules and how Cardhold complies:

| Scryfall rule | Compliance |
|---|---|
| Send a descriptive **User-Agent** + an **Accept** header on every request | ✅ Both set centrally in `SFAPI.request(from:)` (`MTG Collector/Data/SFAPI.swift:23`): `User-Agent` from `AppHTTP.userAgent` and `Accept: application/json`. Every Scryfall call funnels through this builder. |
| Keep request rate reasonable (≤ ~10/s; 429 ⇒ 30 s lockout) | Home loads rows concurrently but capped; deck import batches 75 names/request; daily-suggestion and price data are cached. See `HomeSuggestionsStore`, `DeckImportResolver`, `PriceRefresher`. |
| **No API key** required | None used. |
| **Do not paywall Scryfall data**; software must add its own value | Free tier includes unlimited Search + full Card Info. Pro gates only value-add features (stats, sync, import, unlimited scans) — never the card data. See [Pro & IAP](Features/Pro-IAP.md). |
| Cache where possible | `CardCache` (local SwiftData store) + `URLCache` for art/JSON. See [Price Refresh & Cache](Features/Price-Refresh-and-Cache.md). |
| Link back to Scryfall / attribute | Settings → Legal links to scryfall.com; `Card.scryfallURI` is stored for linking. Confirm card pages link out where data is shown. |

## 4. Wizards of the Coast IP & the Fan Content Policy

*Not legal advice.* Reference links:
- Our Privacy Policy: https://cardhold.ca/privacy
- Scryfall API Terms: https://scryfall.com/docs/api
- WotC Fan Content Policy: https://company.wizards.com/en/legal/fancontentpolicy

**The app ships with zero card content of its own.** Cardhold contains no Magic: The Gathering art,
names, oracle text, or other Wizards of the Coast IP in its bundle. Every piece of WotC-owned content
shown in the app is **fetched on demand from the Scryfall API and cached locally on the device**
(`CardCache` + `URLCache`). The app is a utility that displays this data and adds its own
features (collections, stats, pricing, decks) on top.

- **This is not "Fan Content."** The Fan Content Policy governs *creating and distributing* fan-made
  content (videos, art, articles, custom cards) using WotC IP. Cardhold neither creates nor
  distributes such content — it surfaces official card data, the same as a collection tracker or
  deckbuilder. So the policy's non-commercial framing for fan content doesn't map onto the app.
- **The relevant permission chain is Scryfall's terms.** The right to display WotC's copyrighted card
  images and names flows through Scryfall, which redistributes that data for building MTG software.
  Cardhold operates fully within those terms: descriptive `User-Agent` + `Accept` headers, no
  paywalling of card data, on-device caching, and Scryfall attribution/links. See §3.
- **Monetization stays on the right side of the line.** We never charge for WotC/Scryfall card data
  (Search + Card Info are free, forever). Pro only unlocks Cardhold's *own* value-add features —
  stats, iCloud sync, import/export, unlimited scanning. We are selling our software, not WotC's IP.
- **Trademark-safe by design.** The name **"Cardhold"** avoids WotC marks ("Magic", "MTG",
  "Gathering") in the title (used only in keywords); no WotC logos appear in the icon or chrome.
- **Cheap insurance kept in place.** The in-app disclaimer (Settings → Legal) states the app is
  independent, unaffiliated with Wizards, ships with no content of its own, and that all MTG IP is
  owned by WotC and sourced from Scryfall. It links to the Privacy Policy and the Scryfall API Terms.
  These cost nothing and pre-empt questions; keep them.

## Pre-submission checklist (external, not code)

- [ ] Confirm the Privacy Policy URL loads in a browser and reads correctly.
- [ ] App Privacy answers set to "Data Not Collected".
- [x] `Accept` header present on all Scryfall requests (`SFAPI.request(from:)`).
- [x] In-app disclaimer states: independent app, ships with no content of its own, MTG IP owned by WotC and sourced from Scryfall (Settings → Legal).
- [x] Monetization stance documented (§4): we sell Cardhold's own features, never WotC/Scryfall card data.
- [ ] App Store Connect metadata: description, keywords, age rating (4+), screenshots, optional preview.
- [ ] Configure signing with the Apple Developer account; TestFlight beta.

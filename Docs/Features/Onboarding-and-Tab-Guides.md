# Onboarding & Tab Guides

## Summary

First launch shows a 4-page onboarding flow (Welcome + one page per tab) over an animated accent-tint
gradient background, with a polished badge per page, a glass "Get Started" button, and an "Explore
Cardhold Pro" button on the last page. After onboarding, the first time the user lands on each main
tab (Home / Search / My Hold — Settings excluded) a one-time **Tab Guide** sheet lists that tab's
features with a short how-to. Each guide shows once (tracked in `UserDefaults`) and is gated on
onboarding being complete.

## Capabilities

- 4 onboarding pages with dynamic paging, entrance/float animations, and a drifting gradient backdrop.
- Welcome page uses the Erben Gothic "Cardhold" wordmark + app icon in a tinted circle.
- Per-tab one-time feature intros (Home/Search/My Hold), content-sized sheets that follow the theme tint.
- Dev "Show Onboarding" replays onboarding and resets the tab guides.

## Code map

| Piece | Location |
|---|---|
| Onboarding flow (pages, paging, Pro button, paywall) | `MTG Collector/OnBoarding/OnBoardingView.swift:33` (`PageInfo:19`) |
| One onboarding page (badge, animations, brand title) | `MTG Collector/OnBoarding/OnBoardPageView.swift:19` |
| Tab guide model + content + sheet | `MTG Collector/OnBoarding/TabGuide.swift:22` (`TabGuideSheet:115`) |
| Guide presentation (once-per-tab, onboarding-gated) | `MTG Collector/MTG_TabView.swift` (`presentGuide(for:)`, `activeGuide`) |
| Onboarding flag | `MTG Collector/Data/Models/Settings.swift:19` (`onBoarding`) |
| Dev replay (resets guides) | `MTG Collector/Settings/SettingsTabView.swift` (`#if DEBUG` "Show Onboarding") |

## Notes

- Tab-guide sheets inject `\.appTint` explicitly (sheets don't reliably inherit it).
- Guides fire from three triggers: tab change, onboarding completion (→ Home), and launch for
  returning users.

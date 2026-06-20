# Cardhold Accessibility (App Store)

Store-ready accessibility information for Cardhold. Copy these answers into the **Accessibility
Nutrition Labels** section of App Store Connect, and the blurb below into the App Store description.
For engineering detail and code locations, see [Accessibility.md](Accessibility.md).

Cardhold is a SwiftUI app built on an iOS 26 floor, so it inherits Apple's full accessibility stack
through standard controls and system materials, with custom controls given explicit labels on top.

## Accessibility Nutrition Labels

Declare these for the iPhone (and iPad, if listed) platform in App Store Connect:

| Feature | Supported | What it means in Cardhold |
|---|---|---|
| **VoiceOver** | Yes | Every screen is navigable with VoiceOver. System controls are labelled automatically, and custom elements have spoken labels: card art, price pills ("Foil price $12.50"), rarity pills ("Rare rarity"), and toolbar menus. |
| **Voice Control** | Yes | Built from standard SwiftUI controls, so buttons, fields, toggles and lists respond to Voice Control commands and numbered overlays. |
| **Larger Text (Dynamic Type)** | Yes | All text uses system text styles and scales with the user's preferred reading size. Layouts reflow, and sheets resize to fit their content. The custom "Cardhold" wordmark also scales with Dynamic Type. |
| **Bold Text** | Yes | Honours the system Bold Text setting throughout. |
| **Sufficient Contrast** | Yes | Uses system materials and colours that adapt to Increase Contrast and Reduce Transparency. |
| **Reduced Motion** | Yes | Decorative, looping animations (the ambient gradient background, the Pro shine effects, and the onboarding icon float) are disabled when Reduce Motion is on. Functional transitions remain. |
| **Dark Interface** | Yes | Full Dark Mode support; surfaces and text adapt automatically, and the accent colour is user-selectable. |
| **Differentiate Without Color Alone** | Yes | Information carried by colour is always paired with text or an icon. Rarity, format legality, and card colours all show a written label, not just a colour. |
| **Captions** | Not applicable | The app contains no video or audio media. |
| **Audio Descriptions** | Not applicable | The app contains no video or audio media. |

## Suggested App Store description blurb

> **Accessibility**
> Cardhold is built to work for everyone. It fully supports VoiceOver, Dynamic Type (larger text),
> Bold Text, Reduced Motion, and Dark Mode, and never relies on colour alone to convey information.
> Rarity, format legality, and card colours are always labelled in text.

## User-facing accessibility features

- **VoiceOver throughout**, with spoken labels written for custom controls (card images, price and
  rarity pills, icon menus) so nothing reads as a bare number or unlabeled button.
- **Dynamic Type**: text scales with the system reading-size setting, including the app's display
  type; screens reflow rather than truncate.
- **Bold Text** and **Increase Contrast / Reduce Transparency** are respected via system styling.
- **Reduced Motion**: ambient and decorative animations switch off when the setting is enabled.
- **Dark Mode** across the whole app, plus a user-selectable accent colour.
- **No colour-only signals**: rarity, legality and card colour identity always include a text label.
- **Beginner Hints**: built-in tap-to-learn explanations for Magic-specific concepts (keywords, card
  traits, deck roles, format legality), supporting players who are new to the game.

## Notes before submitting

- Apple's Accessibility Nutrition Labels are self-declared. Do a quick on-device pass with VoiceOver
  on and Dynamic Type at a large size to confirm each "Yes" above before submitting.
- If you set an unusually low-contrast custom accent colour, verify contrast on the price/legality
  chips; the defaults are fine.

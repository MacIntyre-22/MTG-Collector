# Deck Suggestion Engine — Plan

← Back to [CLAUDE.md](CLAUDE.md)

## Overview

An on-device deck suggestion engine. A Create ML trained tabular model diagnoses deck weaknesses from stats, then targeted Scryfall queries find the actual cards that fix each weakness. No API costs, no subscription, fully offline after training.

---

## How It Works

```
Deck stats (from CollectionStats)
        ↓
Core ML tabular model
        ↓
Weakness flags: { needsLands, needsRamp, needsRemoval, needsCardDraw, curveTooHigh, ... }
        ↓
For each weakness → Scryfall query filtered by colour identity + format + EDHREC rank
        ↓
Suggestions displayed with plain-English reasoning
```

---

## The Model

**Type:** Create ML tabular classifier / multi-label classifier
**Framework:** Core ML (on-device inference, iOS 17+, no API costs)
**Input:** deck stat features (numerical + categorical)
**Output:** weakness flags (multi-label boolean classification)

### Input Features

| Feature | Type | Notes |
|---|---|---|
| `land_count` | Int | Total lands in mainboard |
| `avg_cmc` | Double | Average mana cost of non-land cards |
| `creature_count` | Int | |
| `instant_count` | Int | |
| `sorcery_count` | Int | |
| `artifact_count` | Int | |
| `enchantment_count` | Int | |
| `planeswalker_count` | Int | |
| `removal_count` | Int | Cards with removal keywords (destroy, exile, -X/-X) |
| `card_draw_count` | Int | Cards with draw keywords |
| `ramp_count` | Int | Cards that produce mana or fetch lands |
| `total_cards` | Int | Mainboard size |
| `color_count` | Int | Number of colours in colour identity (1–5) |
| `format` | String | commander, modern, standard, legacy, pauper, casual |
| `has_commander` | Bool | Commander format only |

### Output Labels (Weakness Flags)

| Label | Meaning |
|---|---|
| `needs_more_lands` | Land count below recommended for format |
| `needs_less_lands` | Land count above recommended |
| `needs_ramp` | Insufficient mana acceleration |
| `needs_removal` | Insufficient removal/interaction |
| `needs_card_draw` | Insufficient card draw/advantage |
| `curve_too_high` | Average CMC above recommended for format |
| `curve_too_low` | May lack late-game threats (casual/commander) |
| `needs_more_creatures` | Too few creatures for creature-based strategy |
| `mainboard_too_small` | Deck below minimum card count for format |
| `mainboard_too_large` | Deck above maximum card count for format |

---

## Training Data

### Generation Strategy

Synthetic data generated programmatically from two sources of knowledge:

1. **Format-specific thresholds** — well-documented rules for each format
2. **Archetype profiles** — encoded from publicly available MTG strategy content (Channel Fireball, Star City Games, MTG design articles)

**Important:** We are not scraping deck lists — we are encoding publicly known strategic principles as labeling rules. This is domain expertise, not proprietary data. The distinction is the same as a chess engine encoding principles from published chess theory.

---

### Archetype Profiles

`archetype` is added as both an **input feature** and a **threshold modifier**. Thresholds that apply to a control deck don't apply to aggro — without archetypes, an aggro deck with 20 lands would incorrectly be flagged as `needs_more_lands`.

| Archetype | Lands | Avg CMC | Creatures | Removal | Card Draw | Ramp | Notes |
|---|---|---|---|---|---|---|---|
| `aggro` | 18–22 | < 2.0 | 20–30 | 6–8 (cheap) | 2–4 (cantrips) | 0–2 | Fast clock, low to the ground |
| `control` | 24–27 | < 2.5 | 4–8 | 10–14 | 8–12 | 2–4 | High removal, lots of draw |
| `midrange` | 22–24 | 2.0–3.0 | 14–20 | 8–10 | 4–6 | 2–4 | Balanced threats and answers |
| `combo` | 20–24 | 2.0–3.5 | 4–10 | 4–6 | 6–10 | 4–8 | Low creatures, tutors, specific pieces |
| `ramp` | 36–40 | 3.5–5.0 | 10–16 | 8–10 | 8–10 | 12–16 | Commander only, high CMC okay |
| `tribal` | 22–24 | 2.0–3.5 | 28–36 | 6–8 | 4–8 | 2–6 | High creature density, shared type |
| `tokens` | 22–24 | 2.5–3.5 | 10–16 | 6–8 | 6–8 | 2–4 | Token generators + payoffs |
| `stax` | 24–26 | 2.0–3.0 | 8–14 | 10–14 | 4–6 | 4–8 | Lock pieces, prison effects |
| `spellslinger` | 22–24 | 2.0–3.0 | 4–10 | 8–12 | 8–12 | 2–4 | Instants/sorceries as primary cards |

Aggro thresholds are sourced from widely published Modern/Standard aggro theory. Commander archetypes (ramp, stax, spellslinger) are sourced from Commander-specific content. These are community-standard definitions, not proprietary.

---

### Additional Input Features (Archetype + Tribal)

Add to the existing feature set:

| Feature | Type | Notes |
|---|---|---|
| `archetype` | String | aggro, control, midrange, combo, ramp, tribal, tokens, stax, spellslinger, casual |
| `dominant_creature_type` | String | Most common creature subtype in the deck (e.g. "Elf", "Zombie", "Dragon") — empty string if not tribal |
| `tribal_density` | Double | Percentage of creatures sharing `dominant_creature_type` (0.0–1.0) |
| `tutor_count` | Int | Cards with "search your library" in oracle text |
| `protection_count` | Int | Cards with hexproof, indestructible, or counter target spell |
| `token_generator_count` | Int | Cards that create tokens |

---

### Additional Output Labels (Tribal + Archetype-Aware)

| Label | Meaning |
|---|---|
| `needs_tribal_support` | Tribal deck with `tribal_density < 0.5` — too few creatures share the type |
| `missing_tribal_payoff` | Has tribal creatures but no lord or tribal payoff card |
| `needs_tutor` | Combo deck with `tutor_count < 4` — can't find combo pieces reliably |
| `needs_protection` | Combo or value engine present but `protection_count < 2` |
| `needs_token_payoffs` | Has token generators but no cards that benefit from having many tokens |

---

### Format-Specific Thresholds (Archetype-Adjusted)

Thresholds are now a function of both format AND archetype. The data generator applies the correct threshold pair:

| Stat | Commander | Modern | Standard | Legacy | Pauper |
|---|---|---|---|---|---|
| Lands (default) | 36–38 | 22–24 | 24–26 | 18–22 | 22–24 |
| Avg CMC (default) | < 3.5 | < 2.2 | < 3.0 | < 2.0 | < 2.5 |
| Removal | ≥ 10 | ≥ 8 | ≥ 8 | ≥ 8 | ≥ 8 |
| Card draw | ≥ 10 | ≥ 4 | ≥ 4 | ≥ 4 | ≥ 4 |
| Ramp | ≥ 10 | ≥ 2 | ≥ 2 | ≥ 2 | ≥ 2 |
| Deck size | 100 | 60 | 60 | 60 | 60 |

Archetype profiles override these defaults where they conflict (e.g. aggro in Modern uses 20 lands, not 22–24).

---

### CSV Schema

```
land_count, avg_cmc, creature_count, instant_count, sorcery_count,
artifact_count, enchantment_count, planeswalker_count, removal_count,
card_draw_count, ramp_count, tutor_count, protection_count,
token_generator_count, total_cards, color_count, format,
has_commander, archetype, dominant_creature_type, tribal_density,
needs_more_lands, needs_less_lands, needs_ramp, needs_removal,
needs_card_draw, curve_too_high, curve_too_low, needs_more_creatures,
mainboard_too_small, mainboard_too_large, needs_tribal_support,
missing_tribal_payoff, needs_tutor, needs_protection, needs_token_payoffs
```

### Data Volume Target

- 10,000–20,000 rows (more archetypes = more rows needed)
- Generate variations by randomising stats within archetype ranges and labelling algorithmically
- Include edge cases: 5-colour decks, mono-colour, hybrid CMC distributions, casual decks with no clear archetype
- Hand-review ~200 rows per archetype to validate labels before training

### Generation Script

Write a Python script (easier for data generation than Swift) that:
1. Loops through all format + archetype combinations
2. Randomly generates stat combinations within that archetype's ranges
3. Applies archetype-adjusted threshold rules to set weakness flags
4. Outputs to CSV

Use Python for this step — numpy/pandas make random data generation trivial. The output CSV is the only artifact; no Python ships with the app.

---

### TODO — Research Free Training Data Sources

- [ ] **MTG JSON** (`mtgjson.com`) — free bulk card data exports including oracle text, keywords, legalities, types. Could be used to pre-compute `removal_count`, `card_draw_count`, `ramp_count` etc. from actual card text rather than manually labelling. Fully free, updated regularly, no TOS issues for this use case.
- [ ] **EDHREC public data** — check if EDHREC exposes any bulk data or datasets beyond what Scryfall already surfaces via `edhrec_rank`. They have some public-facing stats pages worth investigating.
- [ ] **Kaggle MTG datasets** — search Kaggle for community-uploaded MTG deck datasets. Some users have published anonymised deck lists as research datasets. Check licences before using.
- [ ] **MTG Top 8** (`mtgtop8.com`) — competitive deck lists are publicly visible. Investigate whether bulk access is available or permitted — could provide real archetype-labelled data for competitive formats (Modern, Legacy, Standard).
- [ ] **GitHub MTG repositories** — search GitHub for open-source MTG deck datasets or analysis projects that may include labelled training data under permissive licences.
- [ ] **Scryfall bulk data** (`scryfall.com/docs/api/bulk-data`) — Scryfall provides free bulk card data downloads (all cards, oracle cards). Useful for building the keyword detection logic (removal, ramp, draw) without hitting the API per card.

---

## Scryfall Queries Per Weakness

Each weakness flag maps to a Scryfall query template. Colour identity and format legality are injected at runtime from the deck being analysed.

| Weakness | Scryfall Query Template |
|---|---|
| `needs_more_lands` | `t:land c<={COLORS} f:{FORMAT} order:edhrec` |
| `needs_ramp` | `(o:\"add\" or o:\"search your library for a.*land\") c<={COLORS} f:{FORMAT} -t:land order:edhrec` |
| `needs_removal` | `(o:destroy or o:exile or o:\"−\" or o:\"loses all abilities\") c<={COLORS} f:{FORMAT} -t:land order:edhrec` |
| `needs_card_draw` | `o:\"draw\" c<={COLORS} f:{FORMAT} -t:land order:edhrec` |
| `curve_too_high` | `cmc<=2 c<={COLORS} f:{FORMAT} -t:land order:edhrec` |
| `needs_more_creatures` | `t:creature c<={COLORS} f:{FORMAT} order:edhrec` |

Results are filtered to exclude cards already in the deck before displaying.

---

## Suggestion UI

- Accessible from the deck stats sheet (Pro users only)
- Shows weakness categories with a plain-English explanation per category:
  > *"Your deck has 29 lands — Commander decks typically need 36–38. Here are some options in your colours:"*
- Each weakness section shows top 5 Scryfall results in a horizontal card carousel
- User can tap a card to open the sheet carousel, or tap `+` to add directly to the deck
- "Refresh Suggestions" re-runs the model + queries

---

## Architecture

| Component | Responsibility |
|---|---|
| `DeckSuggestionModel.mlmodel` | Core ML model file bundled with the app |
| `DeckSuggestionEngine` | Loads model, takes `CollectionStats`, returns `[WeaknessFlag]` |
| `SuggestionQueryBuilder` | Maps `WeaknessFlag` + deck context → Scryfall query string |
| `DeckSuggestionViewModel` | Orchestrates engine + queries, drives suggestion UI |

`DeckSuggestionEngine` and `SuggestionQueryBuilder` are pure Swift — no SwiftUI, no SwiftData, fully testable.

---

## Training Process

1. Write data generation script → output `deck_training_data.csv`
2. Open Create ML on Mac → New Project → Tabular Classifier
3. Import CSV, set input columns and output labels
4. Train (takes minutes on modern Mac)
5. Evaluate — check precision/recall per weakness label
6. Export as `.mlmodel` → add to Xcode project
7. Re-train periodically if deckbuilding theory evolves or new formats are added

---

## Limitations

- Does not know specific card synergies between individual cards (e.g. Doubling Season + Planeswalkers)
- Does not account for competitive meta — suggestions are theory-based, not tournament-informed
- Commander-specific synergies tied to a specific commander's ability are out of scope for v1
- `archetype` must be set by the user or inferred from deck stats — auto-detection is imperfect

## Future Improvements

- **Auto-detect archetype** from deck composition instead of requiring user input
- **Keyword synergy detection** — use oracle text overlap to identify cards that synergise with existing cards
- **Foundation Models (iOS 26+)** — layer on-device LLM to generate natural language explanations for each suggestion rather than template strings
- **Meta awareness** — periodic model retraining using published tier lists (requires manual update process)

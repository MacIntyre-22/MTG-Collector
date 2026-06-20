# Card Scanner

## Summary

A live, no-tap card scanner built on VisionKit's `DataScannerViewController`. It continuously reads
the largest text line in frame (the card name), plus any set code / collector number / artist on the
bottom line. Instead of firing on a single frame, it runs a **confidence lock**: the same card has to
be held steady for ~0.7 s (a ring fills as it locks) before it resolves against Scryfall — an exact
printing when the set+number are legible, otherwise a fuzzy name match. The resolved card floats up
as a compact preview that expands to the full card info screen, with a **printing picker** so the
user can correct the printing when the bottom line couldn't be read. A guide overlay frames the card,
a torch button helps in low light, and a watchdog restarts the scanner if it freezes. Free tier is
limited to a few scans/day (Pro is unlimited).

## Capabilities

- Continuous recognition with a card-outline guide overlay and a name-banner scan region. The
  on-screen UI is deliberately minimal: just the guide outline, the confidence ring, and the torch /
  history / close controls — no status text or instructions.
- **Confidence lock** — a card must be read consistently for `lockDuration` (~0.1 s, the shipping
  speed) before it resolves; a fill ring shows progress and a medium "locked on" haptic fires on
  success. Stops a single jittery frame from firing a budget-spending lookup.
- **Scan history** — recently scanned cards are saved as a rolling window of the **25 most recent**
  (newest first, persisted to Application Support; oldest drops off as new ones come in, so it never
  grows unbounded). A button at the bottom-right opens a full-screen "History" sheet showing them as
  the same card grid the Search tab uses (image, price, add controls). See `ScanHistoryStore`.
- **Bottom-priority resolution** — the bottom line (set code + collector number) is the primary
  signal, because it's present and clean far more reliably than a stylised title. The name is not
  required to scan, and is used only as a free sanity check when present.
  - *Primary path* — when set code **and** collector number are read, one exact lookup
    (`fetchCard(set:number:)`) pins the printing. No name lookup, no printings fetch — one request.
    This is the workhorse for ~99.9% of cards, old and new, **named or not** (full-art / showcase
    cards with an unreadable title resolve here too; the confidence lock keys on the set/collector
    instead of the name). If a name *was* read and it shares zero significant words with the looked-up
    card (a misread bottom), it's rejected and falls through to the name path — a free check, no extra
    request.
  - *Name fallback* — only when the bottom can't pin a printing (no pair, lookup failed, or the name
    disagreed). Fuzzy-matches the name, then runs the scoring fallback below.
  - *Scoring fallback* — fetches the card's real printings once (by `oracle_id`, also caching them
    for the picker) and scores each on the *distinguishing* fields — collector number (+3,
    substring-tolerant for OCR digit-doubling), set code (+3), release year (+2, read from the
    copyright line), artist (+2), set name (+1). The winner must carry a **hard** signal — a
    collector match, a set-code match, **or a year + artist match together** (the discriminator that
    lets a set-code-less old card resolve to its real era instead of a modern reprint). A year/artist
    match does **not** count as hard if the printing's collector contradicts a number we actually
    read (blocks a promo guessed purely from year/artist). The winner must also clear a floor + beat
    the next distinct printing by a margin, so genuinely ambiguous ties — same year, #, and artist
    across different sets (e.g. Revised vs Summer Magic), or one of a basic land's hundreds of
    printings — fall back to the safe name default rather than guess.
- **Printing-hint accumulation** — set code, collector number and artist are merged across the lock
  window (different frames read different parts of the bottom line), feeding the guarded refinement.
- **Printing picker** — the result sheet's set row is tappable; it opens every printing of the card
  (by `oracle_id`, newest first) as the **same card grid the Search tab uses** (`SearchCardView`) —
  image, price and add controls per printing — so the user adds the exact copy they own directly.
  This is the fix for "always the newest Sol Ring" when the printing can't be OCR'd. Loaded lazily on
  first open (no extra request for scans the user doesn't correct).
- **OCR name cleanup** — normalises curly punctuation, strips stray glyphs (mana pips, symbols the
  recogniser invents on stylised/old frames) and collapses whitespace before matching.
- **Torch toggle** for low-light scanning (shown only on devices with a controllable flash); turned
  off automatically when the scanner closes.
- Session cache so re-reading a card never re-hits the network or spends a scan.
- Daily free-scan limit (2/day): a scan is spent **only when a card is actually presented** in the
  result sheet — a no-match, mis-read, or stray frame never burns the budget, and the paywall is
  shown only once a real card resolves. Pro bypasses it.
- **Haptics:** medium tap on a successful lock; error notification once per no-match transition.
- Gated on `DataScannerViewController.isSupported` (hidden on Simulator / unsupported devices).

## Code map

| Piece | Location |
|---|---|
| Scan candidate (name + printing hints) | `MTG Collector/SharedViews/CardScanner.swift` (`ScanCandidate`) |
| VisionKit representable + coordinator (classify lines) | `MTG Collector/SharedViews/CardScanner.swift` (`DataScannerView`) |
| Torch controller | `MTG Collector/SharedViews/CardScanner.swift` (`Torch`) |
| Scanner sheet (UI, lock, torch, watchdog) | `MTG Collector/SharedViews/CardScanner.swift` (`CardScannerSheet`) |
| Confidence lock (`ingest` / `resolveLocked`) + OCR cleanup (`cleanName`) | `MTG Collector/SharedViews/CardScanner.swift` |
| Lock ring + printing picker | `MTG Collector/SharedViews/CardScanner.swift` (`LockRing`, `PrintingPickerSheet`) |
| All printings of a card | `MTG Collector/Data/SFAPI.swift` (`fetchPrintings(oracleID:)`) |
| Daily scan limit | `MTG Collector/Data/ScanLimit.swift:19` |
| Photo capture (separate) | `MTG Collector/Pickers/CameraPicker.swift:18` |

## Notes

- Requires `NSCameraUsageDescription`. Separate from `CameraPicker` (cover-image photo capture).
- **Tap-to-focus is not wired** — `DataScannerViewController` owns its capture session and doesn't
  expose a focus point, so the scanner runs on continuous autofocus. The torch is the reliable
  low-light lever; revisit focus only if VisionKit exposes it.
- A no-match keeps retrying on each new stable read (the name isn't marked resolved), so repositioning
  the card retries automatically — at the cost of re-hitting the network each lock cycle on a card
  that genuinely can't be read.

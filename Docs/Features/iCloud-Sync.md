# iCloud Sync

## Summary

The app uses a **two-store** SwiftData `ModelContainer`: a **"Synced"** store for lightweight user
data (collections, card IDs, quantities, settings) that syncs to the user's **private CloudKit**
database, and a local-only **"Cache"** store for full card data and stats that never syncs. The two
stores share no relationships, which keeps synced data small and CloudKit-legal. Sync is opt-in and
Pro-gated: the container attaches CloudKit only when the user has enabled it *and* is entitled.
`CloudSyncMonitor` surfaces live status (syncing / up-to-date / error / last-synced) in Settings.

## Capabilities

- Private-database CloudKit sync of binders/decks/card entries/settings across the user's devices.
- Local-only cache + stats (rebuilt on the receiving device after a sync import).
- Opt-in toggle with iCloud account status + live sync activity in Settings (status row hidden when off).
- Deterministic "My Hold" dedupe so two devices converge on one catch-all.

## Code map

| Piece | Location |
|---|---|
| Two-store container (Synced + Cache configs, CloudKit gating) | `MTG Collector/Data/AppModelContainer.swift:23` (cache `:48`, cloud `:60`, local `:70`) |
| Sync status monitor | `MTG Collector/Data/CloudSyncMonitor.swift:22` |
| Sync section (toggle, status, account check) | `MTG Collector/Settings/SettingsTabView.swift` (`syncSection`) |
| Entitlement mirror read at launch | `MTG Collector/Data/AppModelContainer.swift:56` (`isProEntitled`) |
| Stats recompute after sync import | `MTG Collector/MTG_TabView.swift` (`recomputeAllStats`, on `sync.importGeneration`) |

## Notes

- CloudKit requires testing on a real device signed into iCloud (the Simulator is unreliable).
- Sync changes take effect on next launch; Settings shows a restart note when toggled on.
- Models use UUID/string IDs, optional-friendly relationships, and soft-delete (`isDeleted`) for
  CloudKit compatibility.

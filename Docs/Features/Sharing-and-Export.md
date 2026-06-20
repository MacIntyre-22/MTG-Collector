# Sharing & Export

## Summary

A binder or deck can be **shared as a link** (a CloudKit-hosted snapshot opened via a Universal Link)
or **exported** as plain text / CSV compatible with Moxfield, Archidekt, etc. Receiving a shared link
is free and imports a fresh copy (forced out of collection totals); creating a share is a Pro feature.
Import accepts pasted text or `.txt`/`.csv` files from the Files picker, reusing the deck-import
parser.

## Capabilities

- Share a collection as a Universal Link backed by a CloudKit public snapshot.
- Incoming links/files handled at the app root → imported and opened.
- Export a binder/deck to TXT or CSV (Name, Set, Quantity).
- Snapshot import forces `inCollection = false` and carries leader roles.

## Code map

| Piece | Location |
|---|---|
| Snapshot model + factory + importer | `MTG Collector/Data/Sharing/CollectionSnapshot.swift:23` (`Factory:52`, `Importer:88`) |
| Share service (CloudKit fetch/host, link parsing) | `MTG Collector/Data/Sharing/CollectionShareService.swift:34` |
| Exporter (TXT/CSV rows) | `MTG Collector/Data/Sharing/CollectionExporter.swift:34` (`ExportRow:22`) |
| Importer (parse TXT/CSV) | `MTG Collector/Data/Sharing/CollectionImporter.swift:28` (`ImportFormat:21`, `parse:45`) |
| Share/export menu (UI + gating) | `MTG Collector/MyCollection/Widgets/CollectionShareMenu.swift:24` |
| Incoming link/file handling | `MTG Collector/MTG_TabView.swift` (`handleIncomingURL`, `importCardListFile`) |

## Notes

- Sharing/export/import are Pro features; opening a shared link is free.
- See [Deck Import](Deck-Import.md) for the shared parser, [iCloud Sync](iCloud-Sync.md) for CloudKit.

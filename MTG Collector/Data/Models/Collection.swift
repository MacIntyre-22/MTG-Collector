//
//  Collection.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Base @Model for anything that holds cards. Binder and Deck inherit the shared
//         identity / presentation / sync fields from here, which lets the My Hold tab
//         query Collection for a unified list and lets shared stats live in one place
//         (CollectionStats, linked one-to-one).
//  External Types:
//         CollectionStats, Binder, Deck

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@available(iOS 26, *)
@Model
class Collection {

    // MARK: Stored Properties

    /// NOTE: no @Attribute(.unique) — CloudKit-backed stores reject unique constraints.
    var id: String = UUID().uuidString
    var name: String = ""
    var notes: String = ""
    var createdAt: Date = Date()
    var editedAt: Date = Date()

    /// CloudKit conflict resolution + soft delete
    var updatedAt: Date = Date()
    var isDeleted: Bool = false

    /// presentation controls (persist per collection)
    var showPreviews: Bool = true
    var showControls: Bool = true
    var pinned: Bool = false
    var showCover: Bool = true

    /// each collection remembers its own sort independently (no global default)
    var sortBy: String = "editedAt"

    /// Whether this collection counts toward the whole-collection totals (value, card counts,
    /// breakdowns). Binders default on (owned cards); Deck overrides to off (a build, not stock);
    /// anything imported from a shared link is forced off (it's someone else's list). Toggleable
    /// per collection in its edit sheet.
    var inCollection: Bool = true

    /// Cover photo, synced. Stored as external-storage Data so CloudKit ships it as a file rather
    /// than bloating the record. Read/written via the Collection+Cover helpers.
    @Attribute(.externalStorage) var coverImageData: Data?

    // Stats are NOT a relationship here — they live local-only in CollectionStats (cache store),
    // keyed by `id`, and are fetched via StatsStore. This keeps derived data out of CloudKit sync.

    // MARK: Initializer

    init(name: String = "", notes: String = "") {
        self.name = name
        self.notes = notes
        self.createdAt = Date()
        self.editedAt = Date()
        self.updatedAt = Date()
    }
}

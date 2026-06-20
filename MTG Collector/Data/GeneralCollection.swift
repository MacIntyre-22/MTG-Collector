//
//  GeneralCollection.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Guarantees the permanent "My Hold" catch-all binder (isGeneral == true) exists, and that
//      there's exactly one. Runs at app launch so the catch-all is ready before the user ever
//      opens the My Hold tab, and is also called from the tab itself as a safety net.
//  External Types:
//      Binder, StatsStore
//

// MARK: Imports

import SwiftData

// MARK: Types

@MainActor
enum GeneralCollection {

    /// Ensure exactly one permanent "My Hold" catch-all binder exists.
    /// With iCloud sync, two devices can each create their own catch-all before syncing, producing
    /// duplicates. This collapses any extras into the oldest one (deterministic, so both devices
    /// converge on the same keeper), moves their cards over, and normalises the old name.
    static func ensure(context: ModelContext) {
        let allBinders = (try? context.fetch(FetchDescriptor<Binder>())) ?? []
        let generals = allBinders.filter { $0.isGeneral && !$0.isDeleted }

        guard let keeper = generals.min(by: { $0.createdAt < $1.createdAt }) else {
            // None yet — create it.
            context.insert(Binder(name: "My Hold", isGeneral: true))
            return
        }

        // Merge any duplicates into the keeper.
        for duplicate in generals where duplicate.id != keeper.id {
            for entry in duplicate.cards {
                entry.binder = keeper        // reassign the relationship (moves it to the keeper)
            }
            StatsStore.remove(for: duplicate.id, context: context)
            context.delete(duplicate)
        }

        if keeper.name == "General Collection" {
            keeper.name = "My Hold"
        }
    }
}

//
//  CloudSyncMonitor.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Observes SwiftData's underlying CloudKit sync activity (NSPersistentCloudKitContainer
//      events) so the Settings screen can show a real status — syncing / up to date / error /
//      last synced — instead of guessing. Read-only; it never drives sync, just reports it.
//  External Types:
//      (CoreData / CloudKit)
//

// MARK: Imports

import Foundation
import CoreData

// MARK: Monitor

@Observable
final class CloudSyncMonitor {

    static let shared = CloudSyncMonitor()

    enum Status {
        case idle          // nothing has happened yet this launch
        case syncing       // an import/export is in flight
        case upToDate      // last sync finished successfully
        case error         // last sync failed
    }

    private(set) var status: Status = .idle
    /// Human description of what sync is doing right now (while `status == .syncing`).
    private(set) var activity: String?
    /// End time of the most recent successful export (data pushed up).
    private(set) var lastSyncDate: Date?
    private(set) var lastErrorMessage: String?
    /// Increments each time an import finishes (data pulled *down* from another device). Views
    /// observe this to recompute local stats for the freshly-synced collections.
    private(set) var importGeneration: Int = 0

    private var observer: NSObjectProtocol?

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: NSPersistentCloudKitContainer.eventChangedNotification,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let event = note.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey]
                    as? NSPersistentCloudKitContainer.Event else { return }
            self?.handle(event)
        }
    }

    private func handle(_ event: NSPersistentCloudKitContainer.Event) {
        // endDate == nil means the event just started; non-nil means it finished.
        if event.endDate == nil {
            status = .syncing
            switch event.type {
            case .setup:  activity = "Setting up iCloud…"
            case .import: activity = "Downloading your collection…"
            case .export: activity = "Uploading…"
            @unknown default: activity = "Syncing…"
            }
            return
        }
        activity = nil
        if let error = event.error {
            status = .error
            lastErrorMessage = error.localizedDescription
        } else {
            status = .upToDate
            if event.type == .export {
                lastSyncDate = event.endDate
            }
            // Data came down from another device — signal a recompute of local stats.
            if event.type == .import {
                importGeneration += 1
            }
        }
    }
}

//
//  HomeSuggestionsStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Persists the Home tab's daily card suggestions to a cache file with a date stamp, so the
//      curated set is fetched once per day rather than on every cold launch. Encode/decode is done
//      off the main thread by the caller. A dev option in Settings can invalidate the stamp to
//      force a fresh pull.
//  External Types:
//      HomeSuggestions
//

// MARK: Imports

import Foundation

// MARK: Store

enum HomeSuggestionsStore {

    private static let dateKey = "homeSuggestionsLoadedAt"

    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("home_suggestions.json")
    }

    /// True when suggestions were last saved today — i.e. the cache is still good for the day.
    static func isFreshForToday() -> Bool {
        guard let date = UserDefaults.standard.object(forKey: dateKey) as? Date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    /// Seconds until the next daily refresh (the next local midnight, when `isFreshForToday()` flips
    /// to false and the suggestions refetch on next open).
    static func timeUntilRefresh() -> TimeInterval {
        let cal = Calendar.current
        guard let tomorrow = cal.date(byAdding: .day, value: 1, to: Date()) else { return 0 }
        return max(0, cal.startOfDay(for: tomorrow).timeIntervalSince(Date()))
    }

    /// A short "Refreshes in 5h" / "Refreshes in 45m" label for the discovery list footer.
    static func refreshCountdownText() -> String {
        let total = Int(timeUntilRefresh())
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        if hours >= 1 { return "Refreshes in \(hours)h" }
        return "Refreshes in \(max(minutes, 1))m"
    }

    static func load() -> HomeSuggestions? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try? JSONDecoder().decode(HomeSuggestions.self, from: data)
    }

    static func save(_ suggestions: HomeSuggestions) {
        guard let data = try? JSONEncoder().encode(suggestions) else { return }
        try? data.write(to: fileURL, options: .atomic)
        UserDefaults.standard.set(Date(), forKey: dateKey)
    }

    /// Drop the date stamp so the next load refetches. Used by the Settings dev reload option.
    static func invalidate() {
        UserDefaults.standard.removeObject(forKey: dateKey)
    }
}

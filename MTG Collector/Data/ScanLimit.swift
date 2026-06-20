//
//  ScanLimit.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The free-tier card-scanner budget: 2 identified cards per day. Pro is unlimited and skips
//      this entirely. Persisted in UserDefaults and reset at the local day boundary. A "scan" is one
//      card actually *presented* in the result sheet — a no-match or mis-read never spends the
//      budget, and re-viewing a card already resolved this session (a cache hit) doesn't either.
//

// MARK: Imports

import Foundation

// MARK: Budget

enum ScanLimit {

    /// Free identified-card scans allowed per day.
    static let dailyFree = 2

    private static let countKey = "scanCountToday"
    private static let dateKey  = "scanCountDate"

    /// Scans used so far today (0 once the day rolls over).
    static func usedToday() -> Int {
        let defaults = UserDefaults.standard
        if let date = defaults.object(forKey: dateKey) as? Date, Calendar.current.isDateInToday(date) {
            return defaults.integer(forKey: countKey)
        }
        return 0
    }

    /// Scans left today for a free user.
    static func remainingToday() -> Int { max(0, dailyFree - usedToday()) }

    /// Count one identified card against today's budget (resetting the counter on a new day).
    static func record() {
        let defaults = UserDefaults.standard
        defaults.set(usedToday() + 1, forKey: countKey)
        defaults.set(Date(), forKey: dateKey)
    }
}

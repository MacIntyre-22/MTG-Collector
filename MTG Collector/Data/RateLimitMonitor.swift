//
//  RateLimitMonitor.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Tracks the rate of outgoing Scryfall requests (their guideline is ~10/sec). Every request
//      funnels through SFAPI.request(from:), which calls `record()`. For now it just prints the
//      running total + rolling 1-second count; `requestsInLastSecond` / `isThrottled` are exposed
//      so the UI can later explain to users why content isn't loading when the limit is hit.
//

// MARK: Imports

import Foundation

// MARK: Types

final class RateLimitMonitor {

    static let shared = RateLimitMonitor()

    /// Scryfall asks for a maximum of ~10 requests/second.
    let limitPerSecond = 10

    private let queue = DispatchQueue(label: "net.benmacintyre.cardhoard.ratelimit")
    private var timestamps: [Date] = []
    private var total = 0

    private init() {}

    /// Record one outgoing request and print the current rate.
    func record() {
        queue.async {
            let now = Date()
            self.total += 1
            self.timestamps.append(now)
            self.timestamps.removeAll { now.timeIntervalSince($0) > 1 }
            let inWindow = self.timestamps.count
            let flag = inWindow > self.limitPerSecond ? "  ⚠️ OVER LIMIT" : ""
            print("[Scryfall] request #\(self.total) — \(inWindow)/\(self.limitPerSecond) req/s\(flag)")
        }
    }

    /// Requests fired in the last second (for surfacing throttling in the UI later).
    var requestsInLastSecond: Int {
        queue.sync {
            let now = Date()
            timestamps.removeAll { now.timeIntervalSince($0) > 1 }
            return timestamps.count
        }
    }

    var isThrottled: Bool { requestsInLastSecond >= limitPerSecond }
}

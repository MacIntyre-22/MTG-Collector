//
//  ScryfallLimiter.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Central throttle for api.scryfall.com requests. Scryfall asks for a maximum of ~10
//      requests/second; this actor reserves a 100 ms slot per request (= 10/sec) so bursts — the
//      Home tab firing six suggestion rows at once, a deck import batching collections — are spaced
//      out automatically. Callers `await wait()` before each request: it returns immediately when
//      under the limit and sleeps just long enough when not, so the UI never has to know or show it.
//      CDN hosts (card art on img.scryfall.io, symbol SVGs on svgs.scryfall.io, brand logos) are NOT
//      the API and are deliberately left unthrottled — throttling them would only slow image loading.
//

// MARK: Imports

import Foundation

// MARK: Limiter

actor ScryfallLimiter {

    static let shared = ScryfallLimiter()

    /// 100 ms between requests → a ceiling of 10/second, Scryfall's stated maximum.
    private let minInterval: TimeInterval = 0.1

    /// The earliest the next request may fire. Each caller atomically reserves the next slot, so
    /// concurrent callers queue into back-to-back 100 ms windows instead of all firing at once.
    private var nextSlot = Date.distantPast

    /// Block until this caller's slot opens. Returns immediately when idle.
    func wait() async {
        let now = Date()
        let slot = max(now, nextSlot)
        nextSlot = slot.addingTimeInterval(minInterval)
        let delay = slot.timeIntervalSince(now)
        if delay > 0 {
            try? await Task.sleep(for: .seconds(delay))
        }
    }
}

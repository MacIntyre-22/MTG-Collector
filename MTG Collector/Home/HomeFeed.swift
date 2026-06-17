//
//  HomeFeed.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Composes the Home feed: a pinned collection preview at the top, then a daily-shuffled mix of
//      suggestion rows and quick-link rows. The order and chosen quick links are driven by a
//      date-seeded RNG, so the feed is stable through the day and only re-rolls on the daily reset
//      (or a dev reload, which folds the reload token into the seed).
//  External Types:
//      HomeSection
//

// MARK: Imports

import Foundation

// MARK: Quick Link

/// A tappable themed discovery that opens a card list (DiscoveryListView).
struct QuickLink: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
    /// Scryfall query (same `q + &order=…` form as HomeSection.query).
    let query: String

    /// The pool the daily builder samples from.
    static let pool: [QuickLink] = [
        QuickLink(title: "Dragons",        systemImage: "flame.fill",          query: "t:dragon+game:paper&order=edhrec&dir=asc"),
        QuickLink(title: "Planeswalkers",  systemImage: "person.fill",         query: "t:planeswalker+game:paper&order=released&dir=desc"),
        QuickLink(title: "Legends",        systemImage: "crown.fill",          query: "t:legendary+t:creature+game:paper&order=edhrec&dir=asc"),
        QuickLink(title: "Reserved List",  systemImage: "lock.fill",           query: "is:reserved+game:paper&order=usd&dir=desc"),
        QuickLink(title: "Showcase Art",   systemImage: "paintpalette.fill",   query: "is:showcase+game:paper&order=released&dir=desc"),
        QuickLink(title: "Lands",          systemImage: "mountain.2.fill",     query: "t:land+-t:basic+game:paper&order=edhrec&dir=asc"),
        QuickLink(title: "Artifacts",      systemImage: "gearshape.fill",      query: "t:artifact+game:paper&order=edhrec&dir=asc"),
        QuickLink(title: "Big Creatures",  systemImage: "tortoise.fill",       query: "pow>=6+game:paper&order=edhrec&dir=asc"),
        QuickLink(title: "Tokens",         systemImage: "sparkle",             query: "t:token&order=released&dir=desc"),
        QuickLink(title: "Equipment",      systemImage: "shield.fill",         query: "t:equipment+game:paper&order=edhrec&dir=asc")
    ]
}

// MARK: Feed Item

enum HomeFeedItem: Identifiable {
    case collectionPreview
    case suggestion(HomeSection)
    case newsFeed

    var id: String {
        switch self {
        case .collectionPreview: return "collection"
        case .suggestion(let s): return "suggestion-\(s.rawValue)"
        case .newsFeed:          return "newsfeed"
        }
    }
}

// MARK: Seeded RNG

/// Deterministic SplitMix64 generator so a given seed always yields the same shuffle.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed == 0 ? 0x9E3779B97F4A7C15 : seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

// MARK: Builder

enum HomeFeed {

    /// Seed keyed on the calendar day (so it changes at the daily reset) plus the dev reload token.
    static func dailySeed(token: Int) -> UInt64 {
        let day = Int(Date().timeIntervalSince1970 / 86_400)
        return UInt64(bitPattern: Int64(day &* 2_654_435_761 &+ token))
    }

    /// Collection preview pinned first, then a shuffled mix of suggestion rows with the news feed
    /// dropped in after the first couple of rows.
    static func build(seed: UInt64) -> [HomeFeedItem] {
        var rng = SeededGenerator(seed: seed)

        var rows = HomeSection.allCases.shuffled(using: &rng).map { HomeFeedItem.suggestion($0) }

        let insertAt = min(2, rows.count)
        rows.insert(.newsFeed, at: insertAt)

        return [.collectionPreview] + rows
    }
}

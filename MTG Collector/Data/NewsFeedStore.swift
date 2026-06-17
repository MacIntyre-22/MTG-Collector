//
//  NewsFeedStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Fetches the three MTG news RSS feeds concurrently, merges by date, and caches the result
//      in UserDefaults for 2 hours so the home feed doesn't hammer the network on every scroll.
//  External Types:
//      NewsSource, NewsItem, RSSParser
//

// MARK: Imports

import Foundation

// MARK: Store

enum NewsFeedStore {

    private static let cacheKey  = "newsFeedCache"
    private static let dateKey   = "newsFeedLoadedAt"
    private static let maxAge: TimeInterval = 2 * 60 * 60  // 2 hours

    // MARK: Cache

    static func isFresh() -> Bool {
        guard let date = UserDefaults.standard.object(forKey: dateKey) as? Date else { return false }
        return Date().timeIntervalSince(date) < maxAge
    }

    static func load() -> [NewsItem]? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode([NewsItem].self, from: data)
    }

    static func save(_ items: [NewsItem]) {
        UserDefaults.standard.set(Date(), forKey: dateKey)
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }

    // MARK: Fetch

    /// Fetch all three feeds concurrently and return items sorted newest-first (max 10 per source).
    static func fetch() async -> [NewsItem] {
        var all: [NewsItem] = []
        await withTaskGroup(of: [NewsItem].self) { group in
            for source in NewsSource.allCases {
                group.addTask { await fetchSource(source) }
            }
            for await items in group { all.append(contentsOf: items) }
        }
        return all.sorted { $0.pubDate > $1.pubDate }
    }

    private static func fetchSource(_ source: NewsSource) async -> [NewsItem] {
        guard let url = URL(string: source.feedURL),
              let (data, _) = try? await URLSession.shared.data(from: url) else { return [] }
        return Array(RSSParser.parse(data: data, source: source).prefix(10))
    }
}

//
//  RSSParser.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Parses RSS 2.0 and Atom feeds into NewsItem values.
//      Handles <media:thumbnail>, <media:content url>, and <enclosure type="image/…"> for thumbnails.
//  External Types:
//      NewsSource
//

// MARK: Imports

import Foundation
import SwiftUI

// MARK: Models

struct NewsItem: Identifiable, Codable {
    let title: String
    let link: String
    let pubDate: Date
    let source: NewsSource
    let thumbnailURL: String?

    var id: String { link }
}

enum NewsSource: String, Codable, CaseIterable {
    case mtggoldfish = "MTGGoldfish"
    case edhrec = "EDHREC"
    case reddit = "r/magicTCG"

    var feedURL: String {
        switch self {
        // MTGGoldfish's old /news.rss path 404s; /feed is their current Atom feed.
        case .mtggoldfish: return "https://www.mtggoldfish.com/feed"
        // Wizards discontinued their RSS feed (all paths 404), replaced with EDHREC's article feed.
        case .edhrec:      return "https://edhrec.com/articles/feed"
        case .reddit:      return "https://www.reddit.com/r/magicTCG.rss"
        }
    }

    var systemImage: String {
        switch self {
        case .mtggoldfish: return "chart.line.uptrend.xyaxis"
        case .edhrec:      return "crown.fill"
        case .reddit:      return "bubble.left.and.bubble.right.fill"
        }
    }

    var color: Color {
        switch self {
        case .mtggoldfish: return .yellow
        case .edhrec:      return .teal
        case .reddit:      return .orange
        }
    }
}

// MARK: Parser

final class RSSParser: NSObject, XMLParserDelegate {

    private let source: NewsSource
    private var items: [NewsItem] = []

    private var inItem    = false
    private var curText   = ""
    private var title     = ""
    private var link      = ""
    private var pubDate: Date?
    private var thumb: String?

    // RFC 2822 (RSS 2.0)
    private static let rfc2822: [DateFormatter] = {
        ["EEE, dd MMM yyyy HH:mm:ss Z",
         "EEE, dd MMM yyyy HH:mm:ss zzz",
         "dd MMM yyyy HH:mm:ss Z"].map { fmt in
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = fmt
            return f
        }
    }()

    // ISO 8601 (Atom)
    private static let iso8601: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    init(source: NewsSource) { self.source = source }

    static func parse(data: Data, source: NewsSource) -> [NewsItem] {
        let delegate = RSSParser(source: source)
        let xml = XMLParser(data: data)
        xml.delegate = delegate
        xml.parse()
        return delegate.items
    }

    // MARK: XMLParserDelegate

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes: [String: String] = [:]
    ) {
        curText = ""

        if elementName == "item" || elementName == "entry" {
            inItem = true
            title = ""; link = ""; pubDate = nil; thumb = nil
            return
        }

        guard inItem else { return }

        // Atom: <link href="...">
        if elementName == "link", let href = attributes["href"], !href.isEmpty {
            link = href
        }

        // <media:thumbnail url="..."> or <media:content url="...">
        let qn = qName ?? elementName
        if qn == "media:thumbnail" || qn == "media:content" {
            if let url = attributes["url"], thumb == nil { thumb = url }
        }

        // <enclosure url="..." type="image/...">
        if elementName == "enclosure",
           let url = attributes["url"],
           let type = attributes["type"],
           type.hasPrefix("image/"),
           thumb == nil {
            thumb = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        curText += string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if elementName == "item" || elementName == "entry" {
            let clean = title.trimmingCharacters(in: .whitespacesAndNewlines).htmlDecoded
            if !clean.isEmpty, !link.isEmpty, let date = pubDate {
                items.append(NewsItem(title: clean, link: link, pubDate: date, source: source, thumbnailURL: thumb))
            }
            inItem = false
            return
        }

        guard inItem else { return }
        let text = curText.trimmingCharacters(in: .whitespacesAndNewlines)

        switch elementName {
        case "title":
            title = text
        case "link":
            if link.isEmpty { link = text }
        case "pubDate":
            pubDate = Self.rfc2822.compactMap { $0.date(from: text) }.first
        case "updated", "published":
            if pubDate == nil { pubDate = Self.iso8601.date(from: text) }
        default:
            break
        }

        curText = ""
    }
}

// MARK: Helpers

private extension String {
    var htmlDecoded: String {
        var s = self
        [("&amp;", "&"), ("&lt;", "<"), ("&gt;", ">"),
         ("&quot;", "\""), ("&#39;", "'"), ("&apos;", "'")].forEach { entity, char in
            s = s.replacingOccurrences(of: entity, with: char)
        }
        return s
    }
}

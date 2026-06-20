//
//  HomeSection.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Describes each daily Home suggestion row (title, icon, blurb, Scryfall query) as a single
//      value, so the Home tab can load each row independently and map results to/from the persisted
//      HomeSuggestions cache.
//  External Types:
//      HomeSuggestions, CardJSON
//

// MARK: Imports

import Foundation

// MARK: Section

enum HomeSection: String, CaseIterable, Identifiable {
    case new, popular, pricey, budget, fullArt, oldSchool

    var id: String { rawValue }

    var title: String {
        switch self {
        case .new:       return "New"
        case .popular:   return "Popular"
        case .pricey:    return "Pricey"
        case .budget:    return "Budget"
        case .fullArt:   return "Full Art"
        case .oldSchool: return "Old School"
        }
    }

    var systemImage: String {
        switch self {
        case .new:       return "sparkles"
        case .popular:   return "chart.line.uptrend.xyaxis"
        case .pricey:    return "crown"
        case .budget:    return "dollarsign"
        case .fullArt:   return "paintbrush.pointed"
        case .oldSchool: return "hourglass"
        }
    }

    var blurb: String {
        switch self {
        case .new:       return "Recently released cards"
        case .popular:   return "Popular cards based on their ranking"
        case .pricey:    return "Some of the most expensive cards"
        case .budget:    return "Cards under $5"
        case .fullArt:   return "Full art and borderless cards"
        case .oldSchool: return "Classic cards with 93 and 97 border"
        }
    }

    var query: String {
        switch self {
        case .new:       return "(is:rare+or+is:mythic)+game:paper+-t:token&order=released&dir=desc"
        case .popular:   return "game:paper+-t:land+-t:token&order=edhrec&dir=asc"
        case .pricey:    return "(is:mythic+or+is:promo)+game:paper&order=usd&dir=desc"
        case .budget:    return "usd<=5+game:paper&order=edhrec&dir=asc"
        // Pure aesthetic pools — order doesn't matter, so let Scryfall draw a random sample from the
        // whole matching set rather than always the same first page.
        case .fullArt:   return "(is:fullart+or+is:borderless+or+is:showcase)+game:paper&order=random"
        case .oldSchool: return "frame:1997+or+frame:1993&order=random"
        }
    }

    // MARK: Daily variety

    /// How deep the random page jump may go for ranked sections (kept small so each stays on-theme —
    /// Pricey shouldn't wander into cheap cards). 1 = no page jump.
    var maxPage: Int {
        switch self {
        case .popular: return 4
        case .pricey:  return 3
        case .budget:  return 8
        default:       return 1   // new (newest-first) + fullArt/oldSchool (order=random)
        }
    }

    /// The query actually fetched today. Full Art / Old School use `order=random` (in `query`);
    /// Popular / Pricey / Budget keep their ranking but jump to a random page so the picks vary day
    /// to day while staying genuinely popular/expensive/cheap; New stays newest-first. The page is
    /// drawn from the day's seed, so it's stable through the day and re-rolls at the daily reset.
    func fetchQuery(seed: UInt64) -> String {
        guard maxPage > 1 else { return query }
        let offset = UInt64(HomeSection.allCases.firstIndex(of: self) ?? 0)
        var rng = SeededGenerator(seed: seed &+ offset &* 0x9E3779B1)
        let page = Int.random(in: 1...maxPage, using: &rng)
        return query + "&page=\(page)"
    }
}

// MARK: Cache mapping

extension HomeSuggestions {
    /// Read/write a section's cards by case, so the per-section loader can map into the persisted blob.
    subscript(_ section: HomeSection) -> [CardJSON] {
        get {
            switch section {
            case .new:       return newCards
            case .popular:   return popularCards
            case .pricey:    return expensive
            case .budget:    return budget
            case .fullArt:   return fullArt
            case .oldSchool: return oldSchool
            }
        }
        set {
            switch section {
            case .new:       newCards = newValue
            case .popular:   popularCards = newValue
            case .pricey:    expensive = newValue
            case .budget:    budget = newValue
            case .fullArt:   fullArt = newValue
            case .oldSchool: oldSchool = newValue
            }
        }
    }
}

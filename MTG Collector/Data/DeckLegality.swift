//
//  DeckLegality.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Shared legality model for decks: maps a card's Scryfall legality for a format into a
//      status with a consistent icon + colour, used by the card cells, the board header counts,
//      and the legality filter so they all agree.
//  External Types:
//      Card
//

// MARK: Imports

import SwiftUI

// MARK: Status

enum LegalityStatus: Hashable {
    case legal
    case notLegal
    case banned
    case restricted
    case unknown

    /// Whether this status is a deck-building problem worth flagging.
    var isProblem: Bool {
        switch self {
        case .notLegal, .banned, .restricted: return true
        default: return false
        }
    }

    var icon: String { "exclamationmark.triangle.fill" }

    /// Restricted reads as a caution (orange); not-legal/banned as an error (red).
    /// Uses the shared fixed status palette so the cell icons match the legality widget.
    var color: Color {
        switch self {
        case .restricted: return .statusOrange
        case .notLegal, .banned: return .statusRed
        default: return .clear
        }
    }

    var label: String {
        switch self {
        case .legal: return "Legal"
        case .notLegal: return "Not Legal"
        case .banned: return "Banned"
        case .restricted: return "Restricted"
        case .unknown: return "Unknown"
        }
    }

    /// Resolve a card's status for the given format (deck rule type).
    static func of(_ card: Card, ruleType: String) -> LegalityStatus {
        switch card.legalities[ruleType] {
        case "legal": return .legal
        case "not_legal": return .notLegal
        case "banned": return .banned
        case "restricted": return .restricted
        default: return .unknown
        }
    }
}

// MARK: Filter

enum LegalityFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case issues = "Issues"
    case legal = "Legal"

    var id: String { rawValue }

    func matches(_ status: LegalityStatus) -> Bool {
        switch self {
        case .all: return true
        case .issues: return status.isProblem
        case .legal: return status == .legal
        }
    }
}

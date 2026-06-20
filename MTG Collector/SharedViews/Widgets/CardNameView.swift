//
//  CardNameView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Renders a Scryfall card name with inline icons instead of raw punctuation:
//        • CardNameParser — pure/testable. Strips the Alchemy "A-" prefix and splits a multi-face
//          "Front // Back" name into parts, choosing a join icon from the card's layout.
//        • CardNameView   — renders the parsed name as a single flowing Text (icons via
//          Text(Image:)), so it truncates cleanly. Used in the card detail title.
//      Display-only: the underlying card.name is never changed (search / import / export / sharing
//      / sorting all keep the raw string).
//

// MARK: Imports

import SwiftUI

// MARK: - Parser

enum CardNameParser {

    struct Parsed {
        /// True when the name is an Arena "rebalanced" card (Scryfall prefixes these with "A-").
        let isAlchemy: Bool
        /// The name split on " // " (a single element for ordinary names).
        let parts: [String]
        /// SF Symbol drawn between parts, chosen from the card's layout.
        let joinIcon: String
    }

    static func parse(name: String, layout: String) -> Parsed {
        var working = name
        var isAlchemy = false
        if working.hasPrefix("A-") {
            isAlchemy = true
            working = String(working.dropFirst(2))
        }
        let parts = working.components(separatedBy: " // ")
        return Parsed(isAlchemy: isAlchemy, parts: parts, joinIcon: icon(for: layout))
    }

    /// Maps a Scryfall layout to an icon that reflects how the card physically works.
    static func icon(for layout: String) -> String {
        switch layout {
        case "split":                                                   return "arrow.left.arrow.right"   // read side by side
        case "transform", "modal_dfc", "reversible_card",
             "double_faced_token":                                      return "arrow.triangle.2.circlepath" // flip to other face
        case "flip":                                                    return "arrow.uturn.up"           // rotate 180°
        case "adventure":                                               return "arrow.turn.down.right"    // side-quest spell
        default:                                                        return "arrow.left.arrow.right"
        }
    }
}

// MARK: - View

/// A card name with the Alchemy prefix and the "//" separator rendered as inline icons.
struct CardNameView: View {
    let name: String
    let layout: String
    var font: Font = .headline

    private var parsed: CardNameParser.Parsed { CardNameParser.parse(name: name, layout: layout) }

    var body: some View {
        rendered
            .font(font)
            .lineLimit(1)
            .truncationMode(.tail)
            .accessibilityLabel(accessibleName)
    }

    /// Builds one Text: optional Alchemy icon, then the name parts joined by the layout icon.
    private var rendered: Text {
        let p = parsed
        var result = Text("")
        if p.isAlchemy {
            result = result + Text(Image(systemName: "testtube.2")) + Text(" ")
        }
        for (index, part) in p.parts.enumerated() {
            if index > 0 {
                result = result + Text(" ") + Text(Image(systemName: p.joinIcon)) + Text(" ")
            }
            result = result + Text(part)
        }
        return result
    }

    /// Spoken name for VoiceOver — no punctuation, "Alchemy" spelled out.
    private var accessibleName: String {
        let p = parsed
        let joined = p.parts.joined(separator: ", ")
        return p.isAlchemy ? "Alchemy \(joined)" : joined
    }
}

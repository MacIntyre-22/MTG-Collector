//
//  InfoDisplayWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      The card detail panel. Rather than just re-printing what's already legible on the card image,
//      it makes the info scannable and adds what the image can't: name + type line up top, a row of
//      tappable trait pills (Alchemy, Reserved List, card type…), tappable keyword chips, the oracle
//      text in a delineated rules box, and de-emphasised flavour. Trait pills and keyword chips both
//      open the shared InfoSheet with plain-language, beginner-facing explainers. Symbols render from
//      cached Scryfall SVGs.
//  External Types:
//      SymbolRowView, OracleSymbolImage, OracleTextView, FlowLayout, KeywordGlossary, InfoDetail,
//      InfoPill, InfoSheet, CardTraits
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoDisplayWidget: View {

    // MARK: Stored Properties

    var name: String?
    var manaCost: String?
    var cmc: Double?
    var typeLine: String?
    var colorIdentity: [String]?
    var power: String?
    var toughness: String?
    var loyalty: String?
    var defense: String?
    var keywords: [String]?
    var producedMana: [String]?
    var oracleText: String?
    var flavorText: String?
    /// Card-level trait pills (Alchemy, Reserved List, card type…). Shown under the type line.
    var traits: [InfoDetail] = []

    // MARK: State

    /// The item whose info sheet is open (tap a keyword chip or trait pill to present it).
    @State private var openInfo: InfoDetail?

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            traitSection
            keywordSection
            producedRow
            rulesBox
            flavorRow
        }
        // Always fill the available width, even for sparse cards (no rules box to stretch it).
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $openInfo) { InfoSheet(detail: $0) }
    }

    // MARK: Header (name + type line — mana cost is already legible on the card image)

    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let name, !name.isEmpty {
                Text(name).font(.title3.bold())
            }
            if let typeLine, !typeLine.isEmpty {
                Text(typeLine)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: Traits (Alchemy, Reserved List, card type…)

    @ViewBuilder
    private var traitSection: some View {
        if !traits.isEmpty {
            FlowLayout(spacing: 6) {
                ForEach(traits) { trait in
                    InfoPill(title: trait.title, leadingIcon: trait.symbol, tint: trait.tint) {
                        openInfo = trait
                    }
                }
            }
        }
    }

    // MARK: Keywords

    @ViewBuilder
    private var keywordSection: some View {
        if let keywords, !keywords.isEmpty {
            FlowLayout(spacing: 6) {
                ForEach(keywords, id: \.self) { keywordChip($0) }
            }
        }
    }

    private func keywordChip(_ keyword: String) -> some View {
        let entry = KeywordGlossary.entry(for: keyword)
        return Button {
            if let entry { openInfo = entry.infoDetail(keyword: keyword) }
        } label: {
            HStack(spacing: 5) {
                Text(keyword).font(.subheadline.weight(.semibold))
                if let entry {
                    // The "?" picks up the keyword type's colour, hinting at its family on the card.
                    Image(systemName: "questionmark.circle").font(.footnote)
                        .foregroundStyle(entry.type.tint)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.primary.opacity(0.08)))
            .foregroundStyle(entry != nil ? .primary : .secondary)
        }
        .buttonStyle(.plain)
        .disabled(entry == nil)
    }

    // MARK: Produced mana

    @ViewBuilder
    private var producedRow: some View {
        if let produced = producedMana, !produced.isEmpty {
            HStack(spacing: 6) {
                Text("Produces").font(.caption).foregroundStyle(.secondary)
                SymbolRowView(colorLetters: produced, symbolSize: 18)
                Spacer()
            }
        }
    }

    // MARK: Rules box

    @ViewBuilder
    private var rulesBox: some View {
        if let text = oracleText, !text.isEmpty {
            OracleTextView(text: text, fontSize: 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primary.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.primary.opacity(0.08))
                )
        }
    }

    // MARK: Flavour

    @ViewBuilder
    private var flavorRow: some View {
        if let flavor = flavorText, !flavor.isEmpty {
            Text(flavor)
                .font(.callout)
                .italic()
                .foregroundStyle(.secondary)
        }
    }

}

// MARK: - Keyword type presentation

/// Display attributes for each keyword family — drives the chip tint and the info-sheet badge.
extension KeywordGlossary.KeywordType {
    var label: String {
        switch self {
        case .ability:     return "Keyword Ability"
        case .action:      return "Keyword Action"
        case .abilityWord: return "Ability Word"
        }
    }

    var icon: String {
        switch self {
        case .ability:     return "sparkles"
        case .action:      return "bolt.fill"
        case .abilityWord: return "tag.fill"
        }
    }

    var tint: Color {
        switch self {
        case .ability:     return .blue
        case .action:      return .green
        case .abilityWord: return .purple
        }
    }

    /// One plain-language sentence explaining what *this kind* of keyword is — most players don't
    /// know the difference, so the sheet teaches the category, not just the specific word.
    var blurb: String {
        switch self {
        case .ability:     return "A built-in ability the card has. The keyword is shorthand for the full rule."
        case .action:      return "An action a player or effect performs, defined once in the rules so cards don't repeat it."
        case .abilityWord: return "An italic flavour label with no rules of its own. It just introduces the ability beside it."
        }
    }
}

// MARK: - Keyword → InfoDetail

extension KeywordGlossary.Entry {
    /// Build the generic info-sheet model for a keyword chip (title uses the "?" icon to mirror the
    /// chip; the coloured badge + blurb come from the keyword's family).
    func infoDetail(keyword: String) -> InfoDetail {
        InfoDetail(
            id: "keyword.\(keyword.lowercased())",
            symbol: "questionmark.circle",
            title: keyword.capitalized,
            category: type.label,
            categoryIcon: type.icon,
            tint: type.tint,
            blurb: type.blurb,
            definition: definition
        )
    }
}

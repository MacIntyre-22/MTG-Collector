//
//  CardInfoSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      One place that turns a card tap into the card-detail *sheet* (replacing the old navigation
//      push) — cleaner and quicker, and consistent everywhere. A card cell binds a `Card?` and sets
//      it on tap; this presents CardInfoView with a drag-to-dismiss grabber. CardInfoView brings its
//      own NavigationStack, so it reads correctly in a sheet.
//

// MARK: Imports

import SwiftUI

// MARK: Modifier

extension View {
    /// Present the card detail as a sheet for the bound card (set by a cell on tap).
    func cardInfoSheet(card: Binding<Card?>) -> some View {
        sheet(item: card) { selected in
            CardInfoView(card: selected)
                .presentationDragIndicator(.visible)
        }
    }
}

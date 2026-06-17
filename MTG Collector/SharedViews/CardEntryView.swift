//
//  CardEntryView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      Displays a card entry with some preview information and controls. The card data is
//      resolved by the parent (via CardStore) and passed in, since a CardEntry now stores
//      only a Scryfall ID. While the card is still loading a placeholder is shown.
//  External Types:
//      CardEntry, Card, CardGridView

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardEntryView: View {

    // MARK: Stored Properties

    var entry: CardEntry
    /// Resolved card data (nil while loading / on a cache+network miss)
    var card: Card?
    var showPreviews: Bool = true
    var showControls: Bool = false

    // MARK: State Properties

    @Environment(\.cardGlass) private var cardGlass
    @State var alertIsShowing: Bool = false

    /// taking closures allows for functionality with different models like binders and decks
    var deleteEntry: (() -> Void)? = nil

    // MARK: View

    var body: some View {
        VStack {

            ZStack(alignment: .topLeading) {
                if let card {
                    CardGridView(card: card, showPreviews: showPreviews, isFoil: entry.isFoil)
                } else {
                    cardPlaceholder
                }
                if !showControls {
                    VStack {
                        Text("x\(entry.quantity)")
                            .foregroundColor(.white)
                            .bold()
                            .shadow(radius: 4)
                            .font(.headline)
                            .padding(5)


                    }
                    .padding(.top, 30)
                }
            }


            if showControls {
                HStack {
                    Button(action: {
                        removeCard()
                    }) {
                        Image(systemName: "minus")
                            .frame(width: 20, height: 20)

                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .bold()
                    }
                    .padding(.trailing, 10)
                    Text("\(entry.quantity)")
                        .font(.title)
                        .foregroundColor(.primary)

                    Button(action: {
                        addCard()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .bold()
                    }
                    .padding(.leading, 10)
                }
                .padding(10)
            }
        }
        .widgetStyle(cardGlass)
        .alert("Are you sure?", isPresented: $alertIsShowing) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let delete = deleteEntry {
                    delete()
                }
            }
        } message: {
            Text("Remove this card from collection?")
        }
    }

    // MARK: Placeholder

    private var cardPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(0.714, contentMode: .fit)
            .frame(maxWidth: 220)
            .overlay(ProgressView())
            .padding(10)
    }

    // MARK: Card Controls

    /// add a quantity to cardentry
    func addCard() {
        entry.quantity += 1
        entry.updatedAt = Date()
    }

    /// remove 1 from quantity or toggle alert to delete the entry from the collection
    func removeCard() {
        if entry.quantity == 1 {
            alertIsShowing.toggle()
        } else {
            entry.quantity -= 1
            entry.updatedAt = Date()
        }
    }
}

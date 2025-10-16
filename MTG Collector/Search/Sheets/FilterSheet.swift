//
//  FilterSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-16.
//

import SwiftUI
import SwiftData

struct FilterSheet: View {
    // get filters
    @Binding var filters: CardFilters

    // for mana range
    @State private var cmcLower: Double = 0
    @State private var cmcUpper: Double = 10

    private let allColors = ["W", "U", "B", "R", "G"]
    private let allTypes = ["Creature", "Instant", "Sorcery", "Artifact", "Enchantment", "Land", "Planeswalker"]
    private let allRarities = ["common", "uncommon", "rare", "mythic"]
    @Query var sets: [SetInfo]

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Colors")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            // go through pre set color list
                            ForEach(allColors, id: \.self) { color in
                                Button {
                                    // if in list remove it, if not add it
                                    toggleColor(color: color)
                                } label: {
                                    // check if in list
                                    // give it color if it is else gray it out
                                    Image(color)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                        .padding(5)
                                        .background(filters.colors.contains(where: { $0 == color }) ? .gray.opacity(0.18) : .gray.opacity(0))
                                        .cornerRadius(5)
                                    
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Card Filters")
        }
    }
    
    
    // toggle Color
    func toggleColor(color: String) {
        if filters.colors.contains(where: { $0 == color }) {
            filters.colors.removeAll(where: { $0 == color })
        } else {
            filters.colors.append(color)
        }
    }
}

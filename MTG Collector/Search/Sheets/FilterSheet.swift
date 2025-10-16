//
//  FilterSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-16.
//

import SwiftUI
import SwiftData

struct FilterSheet: View {
    @Environment(\.dismiss) var dismiss
    
    // get filters
    @Binding var filters: CardFilters
    
    var onSearch: () -> Void

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
                                    toggle(array: &filters.colors, value: color)
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
                
                Section("Types") {
                    ScrollView(.horizontal, showsIndicators: false) {
                       HStack {
                           ForEach(allTypes, id: \.self) { type in
                               Button {
                                   // if in list remove it, if not add it
                                   toggle(array: &filters.types, value: type)
                               } label: {
                                   // check if in list
                                   // give it color if it is else gray it out
                                   Text(type)
                                       .padding(5)
                                       .background(filters.types.contains(where: { $0 == type }) ? .gray.opacity(0.18) : .gray.opacity(0))
                                       .cornerRadius(5)
                                   
                               }
                           }
                       }
                   }
                }
                
                Section("Sets") {
                    
                }
                
                Section("Rarities") {
                    
                }
                
                Section("CMC Range") {
                    
                }
            }
            .navigationTitle("Card Filters")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onSearch()
                        dismiss()
                    } label: {
                        Text("Search")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
    
    
    // MARK: Toggle Filter
    // all filters are arrays of strings
    // removes the given string from given array or adds it if not there
    func toggle(array: inout [String], value: String) {
        // checks if in collection and grabs index
        if let item = array.firstIndex(of: value) {
            // removes from index
            array.remove(at: item)
        } else {
            // or adds the value
            array.append(value)
        }
    }
}

//
//  FilterSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-16.
//

import SwiftUI
import SwiftData

struct FilterSheet: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    // query sets
    @Query var sets: [SetInfo]
    
    // get filters
    @Binding var filters: CardFilters
    
    var onSearch: () -> Void

    // for mana range
    @State private var cmcLower: Double = 0
    @State private var cmcUpper: Double = 10

    private let allColors = ["W", "U", "B", "R", "G"]
    private let allTypes = ["Creature", "Instant", "Sorcery", "Artifact", "Enchantment", "Land", "Planeswalker"]
    private let allRarities = ["common", "uncommon", "rare", "mythic"]
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 15),
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 15)
    ]
    
    
    
    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Colors")) {
                    HStack(alignment: .center) {
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
                            // required so it doesnt make the whole view a btn
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                Section("Types") {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(allTypes, id: \.self) { type in
                            let contains = filters.types.contains(type)
                            Button {
                                toggle(array: &filters.types, value: type)
                            } label: {
                                Text(type)
                                    .foregroundColor(contains ? .white : Color.accentColor)
                                    .lineLimit(1)
                                    .frame(maxWidth: 300, maxHeight: 30)
                                    .padding(5)
                                    .background(contains ? Color.accentColor : .clear)
                                    .cornerRadius(5)
                            }
                            // required so it doesnt make the whole view a btn

                            .buttonStyle(PlainButtonStyle())
                       }
                   }
                   
                }
                
                Section("Sets") {
                    SetsFilterWidget() { code in
                        toggle(array: &filters.sets, value: code)
                    }
                    VStack(alignment: .leading) {
                        // get active set filters
                        Text("Added Sets")
                            .bold()
                            .padding(.bottom, 10)
                        ForEach(filters.sets, id: \.self) { code in
                           if let set = sets.first(where: { $0.code == code }) {
                               Text(set.name.capitalized)
                                   .foregroundColor(.gray)
                           } else {
                               Text(code.uppercased())
                                   .foregroundColor(.secondary)
                           }
                       }
                    }
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

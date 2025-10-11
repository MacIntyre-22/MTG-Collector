//
//  BinderView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct BinderView: View {
    @Environment(\.modelContext) var modelContext
    var binder: Binder
    
    @State var showNotes: Bool = false
    @State var showEdit: Bool = false
    // card sort method
    // default by name
    @State var filter: (CardEntry, CardEntry) -> Bool = { a, b in
        a.card.name < b.card.name
    }

    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // controls
                HStack {
                    Button {
                        binder.showPreviews.toggle()
                    } label: {
                        Text("Previews")
                            .foregroundColor(.white)
                            .padding(5)
                            .frame(maxWidth: 100, maxHeight: 30)
                            .background(binder.showPreviews ? Color.accentColor : Color.gray)
                            .cornerRadius(5)
                    }
                    
                    // basic filter functions for user to choose
                    Menu {
                        Button("Name") {
                            filter = { a, b in a.card.name < b.card.name }
                        }
                        Button("Favourite") {
                            filter = { a, b in a.favourite == true }
                        }
                        Button("Foil") {
                            filter = { a, b in a.isFoil == true }
                        }
                        Menu("Rarity") {
                            Button("Mythic") {
                                filter = { a, b in a.card.rarity == "mythic" }
                            }
                            Button("Rare") {
                                filter = { a, b in a.card.rarity == "rare" }
                            }
                            Button("Uncommon") {
                                filter = { a, b in a.card.rarity == "uncommon" }
                            }
                            Button("Common") {
                                filter = { a, b in a.card.rarity == "Common" }
                            }
                        }
                        Button("CMC") {
                            filter = { a, b in a.card.cmc < b.card.cmc }
                        }
                    } label: {
                        Image(systemName: "slider.vertical.3")
                            .foregroundColor(.white)
                            .frame(maxWidth: 30, maxHeight: 30)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                    }
                    
                    
                    Spacer()
                }
                .padding(10)
                
                
                // card grid
                LazyVGrid(columns: cardColumns) {
                    ForEach(binder.cards.sorted(by: filter)) { entry in
                        
                        //
                        BinderCardView(entry: entry, deleteEntry: {binder.cards.removeAll(where: { $0.id == entry.id }) }, showPreviews: binder.showPreviews)
                            
                    }
                }
            }
            .navigationTitle(binder.name)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Stats", systemImage: "chart.bar"){
                        showEdit.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Notes", systemImage: "note.text"){
                        showNotes.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: "square.and.pencil"){
                        showEdit.toggle()
                    }
                }
            })
            .sheet(isPresented: $showEdit) {
                EditBinderSheet(binder: binder)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showNotes) {
                BinderNotesSheet(binder: binder)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}


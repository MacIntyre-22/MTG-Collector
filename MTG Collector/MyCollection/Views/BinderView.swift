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

    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: cardColumns) {
                    ForEach(binder.cards) { entry in
                        NavigationLink(destination: CardInfoView(card: entry.card)){
                            CardEntryView(
                                entry: entry,
                                deleteEntry: {binder.cards.removeAll { $0.id == entry.id }},
                            )
                        }
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


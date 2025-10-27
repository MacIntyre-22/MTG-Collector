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
    var coverImage: UIImage
    
    @State var showNotes: Bool = false
    @State var showEdit: Bool = false
    @State var showStats: Bool = false

    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    init(binder: Binder) {
        self.binder = binder
        self.coverImage = ImageManager.fetchImage(withIdentifier: binder.id) ?? UIImage(named: "MtgBinder")!
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                HeaderWidget(showCover: binder.showCover, coverImage: coverImage, name: binder.name, price: binder.totalPrice, count: binder.cardCount)
                
                // card grid
                LazyVGrid(columns: cardColumns) {
                    ForEach(binder.cards.sorted(by: { $0.dateAdded > $1.dateAdded})) { entry in
                        
                        //
                        BinderCardView(entry: entry, deleteEntry: {binder.cards.removeAll(where: { $0.id == entry.id }) }, showPreviews: binder.showPreviews, showControls: binder.showControls)
                        
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu{
                        Button("Stats", systemImage: "chart.bar"){
                            showStats.toggle()
                        }
                        Button("Notes", systemImage: "note.text"){
                            showNotes.toggle()
                        }
                        Button("Settings", systemImage: "gearshape"){
                            showEdit.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            })
            .sheet(isPresented: $showStats) {
                BinderStatsSheet(binder: binder)
                
            }
            .sheet(isPresented: $showEdit) {
                EditBinderSheet(binder: binder)
            }
            .sheet(isPresented: $showNotes) {
                BinderNotesSheet(binder: binder)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}


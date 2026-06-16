//
//  BinderView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays a binder's cards on the shared CollectionScreen scaffold (blurred cover
//      background + header). Card cells, toolbar and sheets are binder-specific.
//  External Types:
//      Binder, ImageManager, CollectionScreen, BinderCardView, BinderStatsSheet, EditBinderSheet, BinderNotesSheet, StatsUpdater
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct BinderView: View {

    // MARK: Stored Properties

    var binder: Binder
    var coverImage: UIImage
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @State var showNotes: Bool = false
    @State var showEdit: Bool = false
    @State var showStats: Bool = false

    // MARK: Initializer

    init(binder: Binder) {
        self.binder = binder
        self.coverImage = ImageManager.fetchImage(withIdentifier: binder.id) ?? UIImage(named: "MtgBinder")!
    }

    // MARK: View

    var body: some View {
        CollectionScreen(
            coverImage: coverImage,
            showCover: binder.showCover,
            name: binder.name,
            price: binder.totalPrice,
            count: binder.cardCount
        ) {
            LazyVGrid(columns: cardColumns) {
                ForEach(binder.cards.sorted(by: { $0.dateAdded > $1.dateAdded })) { entry in
                    BinderCardView(
                        entry: entry,
                        deleteEntry: {
                            binder.cards.removeAll(where: { $0.id == entry.id })
                            StatsUpdater.update(binder, context: modelContext)
                        },
                        showPreviews: binder.showPreviews,
                        showControls: binder.showControls
                    )
                }
            }
        }
        .task {
            StatsUpdater.update(binder, context: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Stats", systemImage: "chart.bar") { showStats.toggle() }
                    Button("Notes", systemImage: "note.text") { showNotes.toggle() }
                    Button("Settings", systemImage: "gearshape") { showEdit.toggle() }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
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

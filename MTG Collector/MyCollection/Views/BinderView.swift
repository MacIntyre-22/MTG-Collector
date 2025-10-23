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
            
            ScrollView {
                
                // cover image
                if binder.showCover {
                    VStack {
                        ZStack(alignment: .center) {
                            Color.gray
                                .frame(width: 250, height: 250)
                                .cornerRadius(10)
                            Image(uiImage: coverImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        Text(binder.name)
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Text(binder.totalPrice, format: .currency(code: "CAD"))
                                .padding(5)
                                .foregroundColor(.green)
                                .background(Color.green.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            Image(systemName: "square.stack")
                                .foregroundColor(.primary)
                            Text("\(binder.cardCount)")
                        }
                        
                        Divider()
                        
                    }
                    .padding()
                } else {
                    HStack {
                        Text(binder.name)
                            .font(.title)
                            .bold()
                            .padding(.leading, 20)
                        Spacer()
                    }
                }
                
                
                // card grid
                LazyVGrid(columns: cardColumns) {
                    ForEach(binder.cards) { entry in
                        
                        //
                        BinderCardView(entry: entry, deleteEntry: {binder.cards.removeAll(where: { $0.id == entry.id }) }, showPreviews: binder.showPreviews)
                        
                    }
                }
            }
            .toolbar(content: {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filters", systemImage: "slider.horizontal.3") {
                        print("Hello world")
                    }
                }
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


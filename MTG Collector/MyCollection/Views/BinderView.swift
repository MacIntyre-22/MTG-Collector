//
//  BinderView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct BinderView: View {
    var binder: Binder
    
    @State var showEditSheet: Bool = false
    
    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading){
                    Label("Statistics", systemImage: "chart.bar.xaxis")
                        .fontWeight(.heavy)
                        .font(.subheadline)
                        .padding(.top, 15)

                    Divider()
                    
                    BinderStatsWidget(binder: binder)
                }
                
                VStack(alignment: .leading) {
                    Label("Cards", systemImage: "square.stack")
                        .fontWeight(.heavy)
                        .font(.subheadline)
                        .padding(.top, 15)
                    
                    Divider()
                    ScrollView {
                        LazyVGrid(columns: cardColumns) {
                            ForEach(binder.cards) { entry in
                                NavigationLink(destination: CardInfoView(card: entry.card)){
                                    CardEntryView(entry: entry) {
                                        // set onDelete
                                        binder.cards.removeAll { $0.id == entry.id }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(binder.name)
            .padding(15)
            // edit button
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit", systemImage: "square.and.pencil"){
                        showEditSheet.toggle()
                    }
                }
            })
            .sheet(isPresented: $showEditSheet) {
                
            }
        }
    }
}


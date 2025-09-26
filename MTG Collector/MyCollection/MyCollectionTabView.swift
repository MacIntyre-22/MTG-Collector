//
//  MyCollectionTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI
import SwiftData

struct MyCollectionTabView: View {
    @Query var binders: [Binder]
    @State var newBinder: Bool = false
    
    // stats
    var binderCount: Int {
        binders.count
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Go to Decks") {
                    NavigationLink(destination: AllDecksView()) {
                        AllDecksLinkWidget()
                    }
                }
                
                Section("Binders") {
                    ForEach(binders) { binder in
                        NavigationLink(destination: BinderView(binder: binder)) {
                            BinderLinkWidget(binder: binder)
                        }
                    }
                }
            }
            .listRowSpacing(10)
            .navigationTitle("My Collection")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New", systemImage: "plus"){
                        newBinder.toggle()
                    }
                }
            })
            .sheet(isPresented: $newBinder) {
                NewBinderSheet()
            }
        }
    }
}

#Preview {
    MyCollectionTabView()
}

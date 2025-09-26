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
            ScrollView {
                Text(binderCount.description)
                ForEach(binders) { binder in
                    Text(binder.name)
                }
            }
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

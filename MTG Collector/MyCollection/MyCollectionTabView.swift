//
//  MyCollectionTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI
import SwiftData

struct MyCollectionTabView: View {
    @Environment(\.modelContext) var modelContext
    @Query var binders: [Binder]
    @State var newBinder: Bool = false
    @State var editBinder: Bool = false
    
    @State var showAlert: Bool = false
    @State var selectedBinder: Binder?
    
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("") {
                    NavigationLink(destination: AllDecksView()) {
                        AllDecksLinkWidget()
                    }
                }
                
                Section("Binders") {
                    ForEach(binders) { binder in
                        NavigationLink(destination: BinderView(binder: binder)) {
                            BinderLinkWidget(binder: binder)
                                .contextMenu {
                                    NavigationLink(destination: EditBinderSheet(binder: binder)) {
                                        Text("Edit")
                                    }
                                    
                                    Button("Delete", role: .destructive) {
                                        selectedBinder = binder
                                        showAlert.toggle()
                                    }
                                }
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
            .alert("Confirm", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {}
                
                Button("Delete", role: .destructive) {
                    deleteBinder()
                }
            } message: {
                Text("Delete this Binder?")
            }
        }
    }
    
    func deleteBinder() {
        let tempBinder: Binder? = selectedBinder.unsafelyUnwrapped
        
        if let binder = tempBinder{
            modelContext.delete(binder)
        }
    }
}

#Preview {
    MyCollectionTabView()
}

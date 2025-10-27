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
    // sorted binders
    @Query(sort: \Binder.editedAt, order: .reverse) var binders: [Binder]
    @State var newBinder: Bool = false
    @State var editBinder: Bool = false
    
    @State var showAlert: Bool = false
    @State var selectedBinder: Binder?
    
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                Section("") {
                    NavigationLink(destination: AllDecksView()) {
                        AllDecksLinkWidget()
                    }
                    .padding(10)
                }
                
                Section("") {
                    VStack(spacing: 15) {
                        ForEach(binders.sorted(by: {$0.pinned && !$1.pinned})) { binder in
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
                    .padding(.horizontal, 10)
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

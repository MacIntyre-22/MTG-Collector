//
//  AllBindersView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Displays all of the user's binders (excluding the permanent General Collection).
//      Reached from the "Binders" button on the My Collection tab. Pinned binders sort first,
//      then most recently edited — done in a single sort pass.
//  External Types:
//      Binder, BinderView, BinderLinkWidget, EditBinderSheet, NewBinderSheet
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct AllBindersView: View {

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var binders: [Binder]
    @State var newBinder: Bool = false
    @State var showAlert: Bool = false
    @State var selectedBinder: Binder?

    // MARK: Derived Data

    /// User binders only (the General Collection lives on the tab), pinned first then newest.
    var sortedBinders: [Binder] {
        binders
            .filter { !$0.isGeneral }
            .sorted { a, b in
                a.pinned != b.pinned ? a.pinned : a.editedAt > b.editedAt
            }
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(sortedBinders) { binder in
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
                .padding(.top, 10)
            }
            .navigationTitle("My Binders")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New", systemImage: "plus") {
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

    // MARK: deleteBinder

    func deleteBinder() {
        if let binder = selectedBinder {
            modelContext.delete(binder)
        }
    }
}

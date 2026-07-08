//
//  AllBindersView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Displays all of the user's binders (excluding the permanent General Collection).
//      Reached from the "Binders" button on the My Hold tab. Pinned binders sort first,
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
    @Environment(ProAccessManager.self) private var pro
    @Query var binders: [Binder]
    @State var newBinder: Bool = false
    @State var showPaywall: Bool = false
    /// Context-menu actions, presented as sheets owned here (so they work from a long-press).
    @State private var statsBinder: Binder?
    @State private var notesBinder: Binder?
    @State private var editBinder: Binder?

    /// Free tier allows up to 3 user binders.
    private var canCreate: Bool { pro.isPro || sortedBinders.count < 3 }

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
        // Pushed inside the My Hold NavigationStack, so it must NOT wrap its own (nested
        // NavigationStacks crash on iPad). Binder pushes use the parent stack.
        Group {
            if sortedBinders.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "folder")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    Text("No Binders")
                        .font(.title2.bold())
                    Text("Create a binder to organize cards by set, colour or theme.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    PrimaryGlassButton(title: "New Binder", systemImage: "plus") {
                        if canCreate { newBinder.toggle() } else { showPaywall = true }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(sortedBinders) { binder in
                            NavigationLink(destination: BinderView(binder: binder)) {
                                BinderLinkWidget(binder: binder)
                                    .contextMenu {
                                        // Mirrors the binder screen's toolbar (minus filter).
                                        CollectionShareMenu(target: .binder(binder), compact: false)
                                        Button("Stats", systemImage: "chart.bar") {
                                            if pro.isPro { statsBinder = binder } else { showPaywall = true }
                                        }
                                        Button("Notes", systemImage: "note.text") { notesBinder = binder }
                                        Button("Settings", systemImage: "gearshape") { editBinder = binder }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                }
            }
        }
        .navigationTitle("My Binders")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New", systemImage: "plus") {
                    if canCreate { newBinder.toggle() } else { showPaywall = true }
                }
            }
        })
        .sheet(isPresented: $newBinder) {
            NewBinderSheet()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(item: $statsBinder) { binder in
            BinderStatsSheet(binder: binder)
        }
        .sheet(item: $notesBinder) { binder in
            BinderNotesSheet(binder: binder)
                .presentationDetents([.medium, .large])
        }
        .sheet(item: $editBinder) { binder in
            EditBinderSheet(binder: binder, onDelete: { deleteBinder(binder) })
        }
    }

    // MARK: deleteBinder

    func deleteBinder(_ binder: Binder) {
        Spotlight.remove(kind: .binder, id: binder.id)
        StatsStore.remove(for: binder.id, context: modelContext)
        modelContext.delete(binder)
    }
}

//
//  SetsFilterWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-16.
//  Purpose:
//      The Widget to display some sets to filter by
//  External Types:
//      SetInfo,

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct SortedSet {
    
    // MARK: Stored Properties

    var name: String
    var sets: [SetInfo]
}

struct SetsFilterWidget: View {
    
    // MARK: Stored Properties

    var action: (String) -> Void
    var sortedSets: [SortedSet] {
        [
            /// alphabetically sort the list of sets
            SortedSet(name: "Core Sets", sets: sets.filter { $0.type == "core" }.sorted { $0.name < $1.name }),
            SortedSet(name: "Expansion Sets", sets: sets.filter { $0.type == "expansion" }.sorted { $0.name < $1.name }),
            SortedSet(name: "Master Sets", sets: sets.filter { $0.type == "masters" }.sorted { $0.name < $1.name }),
            SortedSet(name: "Commander Sets", sets: sets.filter { $0.type == "commander" }.sorted { $0.name < $1.name })
        ]
    }
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @Query var sets: [SetInfo]
    
    // MARK: View
    
    var body: some View {
        VStack {
            ForEach(sortedSets, id: \.name) { ss in
                HStack {
                    Text(ss.name)
                    Spacer()
                    Menu {
                        ForEach(ss.sets) { set in
                            Button {
                                action(set.code)
                            } label: {
                                HStack {
                                    /// check if asset exists
                                    /// i dont have every set logo
                                    if UIImage(named: set.code) != nil {
                                        Image(set.code)
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.primary)
                                    } else {
                                        /// default is just planeswalker logo
                                        Image("Logo")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.primary)
                                    }
                                    Text(set.name)
                                }
                            }
                        }
                    } label: {
                    Image(systemName: "chevron.up.chevron.down")
                    }
                }
            }
        }
    }
}



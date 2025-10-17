//
//  SetsFilterWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-16.
//

import SwiftUI
import SwiftData

struct SortedSet {
    var name: String
    var sets: [SetInfo]
}

struct SetsFilterWidget: View {
    @Environment(\.modelContext) var modelContext
    
    // query sets
    @Query var sets: [SetInfo]
    
    // action function
    var action: (String) -> Void
    
    // have to be computed after query so  init doesnt work
    var sortedSets: [SortedSet] {
        [
            SortedSet(name: "Core Sets", sets: sets.filter { $0.type == "core" }),
            SortedSet(name: "Expansion Sets", sets: sets.filter { $0.type == "expansion" }),
            SortedSet(name: "Master Sets", sets: sets.filter { $0.type == "masters" }),
            SortedSet(name: "Commander Sets", sets: sets.filter { $0.type == "commander" })
        ]
    }
    
//    init(action: @escaping (String) -> Void) {
//        self.action = action
//        
//        // core sets
//        self.sortedSets.append(
//            SortedSet(
//                name: "Core Sets",
//                sets: sets.filter { $0.type == "core" }
//                )
//            )
//        
//        // expansion sets
//        self.sortedSets.append(
//            SortedSet(
//                name: "Expansion Sets",
//                sets: sets.filter { $0.type == "expansion" }
//                )
//            )
//        
//        // master sets
//        self.sortedSets.append(
//            SortedSet(
//                name: "Master Sets",
//                sets: sets.filter { $0.type == "master" }
//                )
//            )
//        
//        // commander sets
//        self.sortedSets.append(
//            SortedSet(
//                name: "Commander Sets",
//                sets: sets.filter { $0.type == "commander" }
//                )
//            )
//    
//    }
    
    
    
    var body: some View {
        VStack {
            
            // grab sets
            ForEach(sortedSets, id: \.name) { ss in
                HStack {
                    Text(ss.name)
                    Spacer()
                    Menu {
                        
                        ForEach(ss.sets) { set in
                            Button {
                                // if in list remove it, if not add it
                                action(set.code)
                            } label: {
                                HStack {
                                    // check if asset exists
                                    // i dont have every set logo
                                    if UIImage(named: set.code) != nil {
                                        Image(set.code)
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.primary)
                                    } else {
                                        // default is just mtg logo
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



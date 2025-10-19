//
//  HomeTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI
import SwiftData

struct HomeTabView: View {
    // env
    // to grab sets, updates for any new sets
    @Environment(\.modelContext) var modelContext
    @Query var setList: [SetInfo]
    @State var isLoaded: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                
            }
            .navigationTitle("Home")
        }
        .task {
             // grab set data
             // load once
             // commented out so i stop making calls while testing
            if !isLoaded {
                let tempSets: [SetJSON] = await SFAPI.fetchSetData()
                for set in tempSets {
                    
                    // convert and insert
                    let tempSet: SetInfo = SFAPI.setToModel(json: set)
                    if !setList.contains(where: { $0.code == tempSet.code }) {
                        // insert
                        modelContext.insert(tempSet)
                    }
                }
                isLoaded.toggle()
            }
        }
    }
}


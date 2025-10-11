//
//  BinderCardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//

import SwiftUI

struct BinderCardView: View {
    var entry: CardEntry
    var deleteEntry: () -> Void
    var showPreviews: Bool
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // card nav link
            NavigationLink(destination: CardInfoView(card: entry.card)){
                CardEntryView(
                    entry: entry,
                    showPreviews: showPreviews,
                    deleteEntry: {deleteEntry()},
                )
            }
            
            // controls
            VStack {
                Menu {
                    Button("Toggle Foil") {
                        entry.isFoil.toggle()
                    }
                    
                    Button("Delete", role: .destructive) {
                        deleteEntry()
                    }
                    
                } label: {
                    Image(systemName: "pencil.line")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.accentColor)
                        .cornerRadius(5)
                        .bold()
                        .shadow(radius: 4)
                }
                .padding(5)
                
                Button {
                    entry.favourite.toggle()
                    
                } label: {
                    if entry.favourite {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.pink)
                            .shadow(radius: 4)
                    } else {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.pink)
                            .shadow(radius: 4)
                    }
                
                }
            }
            .padding(.top, 30)
        }
    }
}


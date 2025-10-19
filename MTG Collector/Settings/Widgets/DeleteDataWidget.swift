//
//  DeleteDataWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//

import SwiftUI

struct DeleteDataWidget: View {
    var body: some View {
        ZStack {
            Button(role: .destructive) {
                
            } label: {
                Text("Delete Data")
                    .foregroundColor(.white)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: 600)
                    .frame(minHeight: 45)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
    }
}


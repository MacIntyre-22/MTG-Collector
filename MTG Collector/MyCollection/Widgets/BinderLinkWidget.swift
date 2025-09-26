//
//  BinderLinkWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI
import SwiftData

struct BinderLinkWidget: View {
    var binder: Binder
    
    var body: some View {
        VStack {
            Text(binder.name)
            Divider()
            Text("Total Price: \(binder.totalPrice)")
            Text("Card Count: \(binder.cardCount)")
        }
    }
}


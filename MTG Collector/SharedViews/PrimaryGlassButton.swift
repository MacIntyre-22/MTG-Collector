//
//  PrimaryGlassButton.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      The app's primary call-to-action button — a full-width, capsule, prominent-glass pill tinted
//      with the theme colour. Matches the onboarding "Get Started" button so empty-state CTAs (New
//      Binder / New Deck / Scan a Card) all share one look and dimensions.
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PrimaryGlassButton: View {

    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    @Environment(\.appTint) private var tint

    var body: some View {
        Button(action: action) {
            Group {
                if let systemImage {
                    Label(title, systemImage: systemImage)
                } else {
                    Text(title)
                }
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.capsule)
        .tint(tint)
    }
}

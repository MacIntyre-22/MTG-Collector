//
//  ProUpgradeButton.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The standard in-screen lock used wherever a Pro feature lives *inside* an otherwise-free
//      screen (the import block on the new deck / binder sheets, the iCloud Sync row in Settings).
//      Tapping it opens the paywall. Screen-level Pro features (stats sheets, sharing) navigate
//      straight to the paywall instead and don't use this.
//

// MARK: Imports

import SwiftUI

// MARK: Button

struct ProUpgradeButton: View {

    let title: String
    let message: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline).bold()
                        .foregroundStyle(.primary)
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundStyle(.tint)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

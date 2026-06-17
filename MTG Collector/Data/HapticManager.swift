//
//  HapticManager.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      One place for haptic feedback so calls aren't scattered through views.
//

// MARK: Imports

import UIKit

// MARK: Types

enum HapticManager {

    /// Light tap — adding a card to a collection.
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    /// Medium tap — pinning / unpinning.
    static func medium() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func heavy() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    /// Success notification — e.g. a completed deck import.
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    /// Error notification — e.g. a failed scan or import.
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}

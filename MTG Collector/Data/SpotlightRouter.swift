//
//  SpotlightRouter.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Shared router that carries the identifier of a Spotlight result the user tapped, so the
//      relevant tab/screen can open it. The tab switch is handled in MTG_TabView; pushing the
//      exact binder/deck onto its NavigationStack is wired with the navigation rework (Phase 4).
//  External Types:
//      (none)

// MARK: Imports

import Foundation

// MARK: Types

@MainActor
final class SpotlightRouter: ObservableObject {
    /// The uniqueIdentifier (binder/deck id) of a tapped Spotlight result, or nil.
    @Published var openID: String?
}

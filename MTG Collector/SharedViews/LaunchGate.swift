//
//  LaunchGate.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      A brief launch overlay that holds while the app warms the assets every screen depends on —
//      the Scryfall {symbol}→SVG map and the everyday mana pips (pre-rendered to disk) — so the first
//      card / stats / collection screen draws instantly instead of lagging while pips render one by
//      one. The warm-up is capped (AppPreloader), so a slow or offline network can never trap the
//      user on the splash; anything unfinished simply completes in the background.
//  External Types:
//      SymbolStore, SymbolCache
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Preloader

enum AppPreloader {

    /// Best-effort warm-up of universal assets. Never blocks longer than `maxSeconds`: whichever of
    /// the work or the cap finishes first wins, and unfinished warming continues in the background.
    static func run(maxSeconds: Double = 2.5) async {
        let work = Task {
            await SymbolStore.load()               // {symbol}→SVG map (instant if fresh this week)
            await SymbolCache.shared.warmCommon()  // pre-render everyday pips to disk
        }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await work.value }
            group.addTask { try? await Task.sleep(for: .seconds(maxSeconds)) }
            await group.next()      // return as soon as either the work or the cap completes
            group.cancelAll()       // background warming (no cancellation checks) just keeps going
        }
    }
}

// MARK: Gate

struct LaunchGate<Content: View>: View {

    @ViewBuilder var content: () -> Content

    @State private var ready = false

    var body: some View {
        ZStack {
            content()
            if !ready {
                LaunchSplash()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            // Warm assets, but show the splash for at least a beat so it never flickers when cached.
            async let prep: Void = AppPreloader.run()
            async let floor: Void = minimumDisplay()
            _ = await (prep, floor)
            withAnimation(.easeOut(duration: 0.35)) { ready = true }
        }
    }

    private func minimumDisplay() async {
        try? await Task.sleep(for: .seconds(0.5))
    }
}

// MARK: Splash

private struct LaunchSplash: View {

    @Query private var settingsList: [Settings]

    /// Match the user's accent colour (app-icon blue until Settings exist / is read).
    private var tint: Color { Color(hex: settingsList.first?.theme ?? "#007AFF") ?? .blue }

    var body: some View {
        ZStack {
            // Opaque base so the gradient's blurred edges never reveal the tab behind the splash.
            Color(.systemBackground).ignoresSafeArea()
            AnimatedTintBackground(tint: tint)

            VStack(spacing: 18) {
                Image("CardholdIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(.primary)
                Text("Cardhold")
                    .font(BrandFont.wordmark(40, relativeTo: .largeTitle))
                    .foregroundStyle(.primary)
                ProgressView()
            }
        }
    }
}

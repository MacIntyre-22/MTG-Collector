//
//  CardScanner.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Live card-name scanner using VisionKit's DataScannerViewController. Continuously picks the
//      largest text line in frame (usually the card name), debounces it, resolves it via Scryfall
//      fuzzy match, and floats a card-info overlay (image/name/price) with quick add + search.
//      No tap required; tapping a name still works as a manual override.
//      Separate from CameraPicker (photo capture). Device-only — the Simulator has no camera.
//  External Types:
//      SFAPI, CardJSON, Card, CardImageView, CollectionControllWidget
//

// MARK: Imports

import SwiftUI
import VisionKit

// MARK: Scanner Representable

struct DataScannerView: UIViewControllerRepresentable {

    /// Called continuously with the best card-name candidate currently in frame.
    var onCandidate: (String) -> Void
    /// Limit recognition to this rect (in view coordinates) — the name-banner guide.
    var regionOfInterest: CGRect?
    /// When false the camera stays live but text recognition is paused.
    var isScanning: Bool = true

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ scanner: DataScannerViewController, context: Context) {
        if let regionOfInterest {
            scanner.regionOfInterest = regionOfInterest
        }
        if isScanning {
            try? scanner.startScanning()
        } else {
            scanner.stopScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCandidate: onCandidate)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onCandidate: (String) -> Void
        init(onCandidate: @escaping (String) -> Void) { self.onCandidate = onCandidate }

        func dataScanner(_ s: DataScannerViewController, didAdd added: [RecognizedItem], allItems: [RecognizedItem]) {
            emitBest(allItems)
        }

        func dataScanner(_ s: DataScannerViewController, didUpdate updated: [RecognizedItem], allItems: [RecognizedItem]) {
            emitBest(allItems)
        }

        func dataScanner(_ s: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case let .text(text) = item {
                onCandidate(text.transcript.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }

        /// The card name is almost always the largest text line in frame.
        private func emitBest(_ items: [RecognizedItem]) {
            var bestTranscript = ""
            var bestHeight: CGFloat = 0
            for item in items {
                guard case let .text(text) = item else { continue }
                let transcript = text.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                guard transcript.count >= 3 else { continue }
                let b = text.bounds
                let height = hypot(b.bottomLeft.x - b.topLeft.x, b.bottomLeft.y - b.topLeft.y)
                if height > bestHeight {
                    bestHeight = height
                    bestTranscript = transcript
                }
            }
            if !bestTranscript.isEmpty {
                onCandidate(bestTranscript)
            }
        }
    }
}

// MARK: Guide Overlay

/// Dims outside the full-card outline, draws a prominent card outline to fit the whole card into,
/// and a subtle name-banner box (the actual scan region) sitting where the title lands.
private struct GuideOverlay: View {
    let cardRect: CGRect
    let nameRect: CGRect

    private var cardCorner: CGFloat { cardRect.width * 0.035 }

    var body: some View {
        Color.black.opacity(0.4)
            .mask(
                ZStack {
                    Rectangle()
                    RoundedRectangle(cornerRadius: cardCorner)
                        .frame(width: cardRect.width, height: cardRect.height)
                        .position(x: cardRect.midX, y: cardRect.midY)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
            )
            .overlay {
                // prominent full-card outline
                RoundedRectangle(cornerRadius: cardCorner)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: cardRect.width, height: cardRect.height)
                    .position(x: cardRect.midX, y: cardRect.midY)

                // subtle name-banner box (where scanning actually happens)
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.white.opacity(0.45), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    .frame(width: nameRect.width, height: nameRect.height)
                    .position(x: nameRect.midX, y: nameRect.midY)
            }
            .allowsHitTesting(false)
    }
}

// MARK: Scanner Sheet

struct CardScannerSheet: View {

    /// Called when the user picks a card to view in Search (caller sets the query + dismisses).
    var onSearch: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var detected: CardJSON?
    @State private var candidate = ""
    @State private var isResolving = false
    @State private var noMatch = false
    @State private var lastResolved = ""
    @State private var isScanning = true
    @State private var sheetDetent: PresentationDetent = .medium
    @State private var resolveTask: Task<Void, Never>?
    /// Resolved names cached for the session so re-reading a card never re-hits the network.
    @State private var cache: [String: CardJSON] = [:]

    var body: some View {
        ZStack {
            // full-bleed camera layer (ignores safe area)
            GeometryReader { geo in
                let card = cardRect(in: geo.size)
                let name = nameRect(in: card)

                ZStack {
                    DataScannerView(onCandidate: { candidate in
                        scheduleResolve(candidate)
                    }, regionOfInterest: name, isScanning: isScanning)

                    GuideOverlay(cardRect: card, nameRect: name)

                    Text("Fit the whole card in the frame")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.45), in: Capsule())
                        .position(x: geo.size.width / 2, y: card.maxY + 24)
                }
            }
            .ignoresSafeArea()

            // controls layer — a sibling that respects the safe area
            VStack(spacing: 10) {
                header
                statusPill
                Spacer()
            }
            .padding()
        }
        .sheet(item: $detected, onDismiss: { isScanning = true; sheetDetent = .medium }) { json in
            resultSheet(SFAPI.JSONtoModel(json: json))
        }
    }

    /// A portrait card outline (MTG aspect ≈ 0.714) centred and nudged up to leave room for the overlay.
    private func cardRect(in size: CGSize) -> CGRect {
        var width = size.width * 0.82
        var height = width / 0.714
        let maxHeight = size.height * 0.62
        if height > maxHeight {
            height = maxHeight
            width = height * 0.714
        }
        let x = (size.width - width) / 2
        let y = (size.height - height) / 2 - size.height * 0.05
        return CGRect(x: x, y: y, width: width, height: height)
    }

    /// The title banner inside the card — the actual scan region.
    private func nameRect(in card: CGRect) -> CGRect {
        let inset = card.width * 0.05
        return CGRect(
            x: card.minX + inset,
            y: card.minY + card.height * 0.045,
            width: card.width - inset * 2,
            height: card.height * 0.08
        )
    }

    // MARK: Status

    @ViewBuilder
    private var statusPill: some View {
        let text: String? = {
            if candidate.isEmpty { return nil }
            if isResolving { return "Searching “\(candidate)”…" }
            if noMatch && detected == nil { return "No match for “\(candidate)”" }
            return nil
        }()

        if let text {
            HStack(spacing: 6) {
                if isResolving { ProgressView().tint(.white) }
                Text(text)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.black.opacity(0.45), in: Capsule())
        }
    }

    // MARK: Subviews

    private var header: some View {
        HStack {
            Text("Point at a card name")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.black.opacity(0.45), in: Capsule())
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white, .black.opacity(0.4))
                    .shadow(radius: 4)
            }
        }
    }

    /// The detected card as a dismissible sheet: a card-grid preview at medium, expanding to the
    /// full CardInfoView detail screen when pulled up to large.
    private func resultSheet(_ card: Card) -> some View {
        Group {
            if sheetDetent == .large {
                CardInfoView(card: card)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        // card-grid item with the add control on top, like the search results
                        ZStack(alignment: .topLeading) {
                            CardGridView(card: card, showPreviews: true)
                            Menu {
                                CollectionControllWidget(card: card)
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.accentColor)
                                    .cornerRadius(5)
                                    .bold()
                                    .shadow(radius: 4)
                            }
                            .padding(8)
                        }
                        .frame(maxWidth: 260)

                        // tap the text to view in Search
                        Button {
                            onSearch(card.name)
                        } label: {
                            VStack(spacing: 4) {
                                Text(card.name)
                                    .font(.title3.bold())
                                    .multilineTextAlignment(.center)
                                Text(card.typeLine)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        Text("Pull up for full details")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .presentationDetents([.medium, .large], selection: $sheetDetent)
        .presentationDragIndicator(.visible)
    }

    /// Pause scanning and present the resolved card (compact first).
    private func present(_ card: CardJSON, key: String) {
        lastResolved = key
        noMatch = false
        isScanning = false
        sheetDetent = .medium
        detected = card
    }

    // MARK: Resolve

    /// Debounce the live candidate, then resolve it via Scryfall fuzzy match (skipping repeats).
    private func scheduleResolve(_ name: String) {
        let cleaned = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleaned.count >= 3 else { return }
        if cleaned != candidate { candidate = cleaned }

        let key = cleaned.lowercased()
        // already showing this card — nothing to do (no network)
        if key == lastResolved { return }

        resolveTask?.cancel()
        resolveTask = Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            if Task.isCancelled || key == lastResolved { return }

            // cache hit — no request
            if let cached = cache[key] {
                present(cached, key: key)
                return
            }

            isResolving = true
            let card = await SFAPI.fetchCardNamed(fuzzy: cleaned)
            isResolving = false

            if let card {
                cache[key] = card
                present(card, key: key)
            } else {
                noMatch = true
            }
        }
    }
}

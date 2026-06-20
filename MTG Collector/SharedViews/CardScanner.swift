//
//  CardScanner.swift
//  Cardhold
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
import AVFoundation

// MARK: Torch

/// Drives the capture device's torch for low-light scanning. `DataScannerViewController` owns the
/// session but shares the physical back camera, so toggling the default video device's torch lights
/// the same live feed.
enum Torch {
    /// Whether the current device has a controllable torch (back camera only).
    static var isAvailable: Bool {
        AVCaptureDevice.default(for: .video)?.hasTorch ?? false
    }

    static func set(_ on: Bool) {
        // Off the main thread: acquiring the capture device's configuration lock can block while
        // DataScannerViewController is configuring the same session, which froze the live preview /
        // UI until the torch was toggled back off. Doing it on a background queue keeps the UI fluid.
        DispatchQueue.global(qos: .userInitiated).async {
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                device.unlockForConfiguration()
            } catch {
                // Torch unavailable (e.g. overheated) — fail silently; scanning still works.
            }
        }
    }
}

// MARK: Bottom-line tokenising

/// Characters that separate tokens on a card's bottom info line. Newlines/tabs matter: the
/// recogniser glues the rarity letter to the set code across a break ("C\nMID"). `*` matters because
/// some frames print the set/lang divider as `CMM*EN` with no spaces.
private let scannerTokenSeparators: Set<Character> = [" ", "•", "·", "/", "*", "\n", "\t", "\r"]

// MARK: Scan Candidate

/// What a single frame yielded: the card name (largest top line) plus whatever bottom-line info was
/// legible — set code + collector number (pin down the exact printing) and the artist credit
/// (disambiguates alternate arts when the tiny set/collector text can't be read).
struct ScanCandidate: Equatable {
    var name: String
    var setCode: String?
    var collectorNumber: String?
    var artist: String?
    /// True when the user explicitly tapped a name — bypasses the confidence lock and resolves now.
    var isManual: Bool = false
    /// The raw bottom-line text the recogniser produced (accumulated across the lock). Fed to the
    /// printing-scoring fallback to match year / artist / collector against the card's real printings.
    var rawBottomLines: [String] = []

    /// Whether we read anything beyond the name to narrow the printing.
    var hasPrintingHints: Bool { setCode != nil || collectorNumber != nil || artist != nil }

    /// Stable identity for de-duping / caching: the exact printing if known, else name + whatever
    /// extra signal we have, so two different printings of the same card don't collide.
    var key: String {
        if let setCode, let collectorNumber { return "\(setCode)/\(collectorNumber)" }
        var k = name.lowercased()
        if let collectorNumber { k += "#\(collectorNumber)" }
        if let artist { k += "@\(artist.lowercased())" }
        return k
    }
}

// MARK: Scanner Representable

struct DataScannerView: UIViewControllerRepresentable {

    /// Called continuously with the best candidate currently in frame.
    var onCandidate: (ScanCandidate) -> Void
    /// The full card outline (view coordinates) — used both as the scan region and to split the
    /// name (top) from the set/collector line (bottom).
    var cardRect: CGRect
    /// When false the camera stays live but text recognition is paused.
    var isScanning: Bool = true
    /// Toggling this stops then restarts the underlying scanner, clearing any stuck state.
    var resetToken: Bool = false

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
        context.coordinator.cardRect = cardRect
        scanner.regionOfInterest = cardRect

        // Reset: stop then immediately restart to clear any frozen highlight state.
        if context.coordinator.lastResetToken != resetToken {
            context.coordinator.lastResetToken = resetToken
            scanner.stopScanning()
            try? scanner.startScanning()
            return
        }

        if isScanning {
            try? scanner.startScanning()
        } else {
            scanner.stopScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onCandidate: onCandidate, cardRect: cardRect)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onCandidate: (ScanCandidate) -> Void
        var cardRect: CGRect
        var lastResetToken: Bool = false
        init(onCandidate: @escaping (ScanCandidate) -> Void, cardRect: CGRect) {
            self.onCandidate = onCandidate
            self.cardRect = cardRect
        }

        func dataScanner(_ s: DataScannerViewController, didAdd added: [RecognizedItem], allItems: [RecognizedItem]) {
            emitBest(allItems)
        }

        func dataScanner(_ s: DataScannerViewController, didUpdate updated: [RecognizedItem], allItems: [RecognizedItem]) {
            emitBest(allItems)
        }

        func dataScanner(_ s: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case let .text(text) = item {
                let name = text.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                if !name.isEmpty { onCandidate(ScanCandidate(name: name, isManual: true)) }
            }
        }

        /// Classify recognised lines: the tallest line in the top half is the name; lines in the very
        /// bottom strip (the collector / set / artist line) feed the printing parse. The strip is kept
        /// tight (bottom ~14%) so the rules-text box above it can't pollute the set/collector parse.
        private func emitBest(_ items: [RecognizedItem]) {
            let topLimit = cardRect.minY + cardRect.height * 0.5
            let bottomLimit = cardRect.minY + cardRect.height * 0.86

            var bestName = ""
            var bestHeight: CGFloat = 0
            var bottomLines: [String] = []

            for item in items {
                guard case let .text(text) = item else { continue }
                let transcript = text.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !transcript.isEmpty else { continue }
                let b = text.bounds
                let midY = (b.topLeft.y + b.bottomLeft.y) / 2
                let height = hypot(b.bottomLeft.x - b.topLeft.x, b.bottomLeft.y - b.topLeft.y)

                if midY <= topLimit, transcript.count >= 3, height > bestHeight {
                    bestHeight = height
                    bestName = transcript
                } else if midY >= bottomLimit {
                    bottomLines.append(transcript)
                }
            }

            let printing = Self.parsePrinting(from: bottomLines)
            // Emit when the name is readable OR — for full-art / showcase cards whose stylised title
            // can't be OCR'd — when the bottom line alone pins a printing (set + collector number).
            guard bestName.count >= 3 || (printing.set != nil && printing.number != nil) else { return }
            onCandidate(ScanCandidate(
                name: bestName,
                setCode: printing.set,
                collectorNumber: printing.number,
                artist: Self.artist(from: bottomLines),
                rawBottomLines: bottomLines
            ))
        }

        /// The artist credit from the "Illus. <name>" line at the bottom of the card.
        private static func artist(from lines: [String]) -> String? {
            for line in lines {
                let lower = line.lowercased()
                guard let r = lower.range(of: "illus") else { continue }
                var name = String(line[r.upperBound...])
                name = name.trimmingCharacters(in: CharacterSet(charactersIn: ". •·:&"))
                            .trimmingCharacters(in: .whitespaces)
                if name.count >= 3 { return name }
            }
            return nil
        }

        /// Parse the set code and collector number **together**. They share the same bottom-left block
        /// (e.g. "0556 / CMM • EN", "135/277 C / MID • EN"), so the collector number is taken from the
        /// *same line* that yields the set code. That structurally excludes a creature's power /
        /// toughness ("5/5") and copyright years, which sit in other text items. Falls back to a
        /// global best-effort collector when no set code is legible (foreign / very old cards).
        private static func parsePrinting(from lines: [String]) -> (set: String?, number: String?) {
            for line in lines {
                let tokens = line.split { scannerTokenSeparators.contains($0) }.map(String.init)
                guard let set = setCode(from: tokens) else { continue }
                return (set, collectorNumber(onSetLine: line, tokens: tokens))
            }
            return (nil, collectorNumber(fromLines: lines))
        }

        /// A token that validates against a known set code (e.g. "C21", "NEO", "MID"). Relies on the
        /// rarity letter being split off as its own token (newline / space / `*` / `•` separators),
        /// so we never strip a leading letter — that used to turn the artist "Steve" into "teve".
        private static func setCode(from tokens: [String]) -> String? {
            for raw in tokens {
                let t = raw.lowercased().filter { $0.isLetter || $0.isNumber }
                if isKnownSet(t) { return t }
            }
            return nil
        }

        private static func isKnownSet(_ code: String) -> Bool {
            (3...5).contains(code.count) && SetIconRegistry.shared.iconURI(for: code) != nil
        }

        /// Collector number from the set-code line: the "N/M" collector/set-size pattern (set size
        /// ≥ 20, so power/toughness like "5/5" can't match), else a standalone 2–4 digit number
        /// ("0556", "0221", "317", "1269"), skipping copyright years.
        private static func collectorNumber(onSetLine line: String, tokens: [String]) -> String? {
            if let n = collectorFromRatio(line) { return n }
            for raw in tokens {
                let digits = String(raw.prefix { $0.isNumber })
                guard (2...4).contains(digits.count), let n = Int(digits) else { continue }
                if (1990...2099).contains(n) { continue }   // skip "™ © 2021 Wizards…"
                return String(n)
            }
            return nil
        }

        /// Global best-effort collector (set-less old cards): **only** the "N/M" collector/set-size
        /// ratio. A bare standalone digit is too risky without a set line — it tends to grab a
        /// creature's power/toughness ("2/2") — so a card with no ratio simply yields no collector.
        private static func collectorNumber(fromLines lines: [String]) -> String? {
            for line in lines {
                if let n = collectorFromRatio(line) { return n }
            }
            return nil
        }

        /// The numerator of a "collector / set-size" ratio (e.g. "135/277" → "135"), requiring the
        /// set size ≥ 20 so a creature's power/toughness ("5/5", "3/2") can't be mistaken for it.
        private static func collectorFromRatio(_ line: String) -> String? {
            guard let r = line.range(of: #"\d{1,4}\s*/\s*\d{1,4}"#, options: .regularExpression) else { return nil }
            let parts = line[r].split(separator: "/")
            guard parts.count == 2,
                  let n = Int(parts[0].filter(\.isNumber)),
                  let m = Int(parts[1].filter(\.isNumber)), m >= 20 else { return nil }
            return String(n)
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

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTint) private var tint
    @Environment(\.appCurrency) private var currency
    @Environment(ProAccessManager.self) private var pro

    /// Free tier: limited daily scans. Pro is unlimited and bypasses the gate.
    @State private var showPaywall = false
    @State private var remaining = ScanLimit.remainingToday()

    @State private var detected: CardJSON?
    @State private var candidate = ""
    @State private var isResolving = false
    @State private var noMatch = false
    @State private var lastResolved = ""
    @State private var isScanning = true

    // MARK: Confidence lock
    /// Normalised name currently building a lock. The scanner only resolves once the *same* card has
    /// been held steady for `lockDuration`, so a single jittery frame can't fire a (budget-spending)
    /// resolve. Printing hints are accumulated across the whole lock window — different frames often
    /// read the name, set code, collector number and artist at different moments — which gives the
    /// best possible shot at the exact printing.
    @State private var lockKey = ""
    @State private var lockCandidate: ScanCandidate?
    @State private var lockStart: Date?
    @State private var lockProgress: Double = 0
    /// How long a card must be held steady before it resolves. 0.1 s — a fast snap; accuracy holds at
    /// this speed because the bottom-line parse is validated (set code checked, collector paired).
    private let lockDuration: TimeInterval = 0.1

    // MARK: Torch
    @State private var torchOn = false
    private var torchAvailable: Bool { Torch.isAvailable }

    /// Full-screen scan-history sheet (every card the scanner has presented).
    @State private var showHistory = false

    // MARK: Printing picker
    /// Every printing of the resolved card. Tapping the set row opens these as a Search-style card
    /// grid (image + price + add controls), so the user can add the exact copy they own — the fix for
    /// "always the newest Sol Ring" when the bottom line can't be OCR'd (older cards, special art).
    @State private var printings: [CardJSON] = []
    @State private var loadingPrintings = false
    @State private var showPrintingPicker = false
    @State private var sheetDetent: PresentationDetent = .height(Self.compactSheetHeight)
    @State private var resolveTask: Task<Void, Never>?
    /// Fixed image size + compact-sheet height. Deterministic (not measured) so the result sheet can't
    /// collapse to a sliver from an early-small geometry read while the card art is still loading.
    private static let cardImageWidth: CGFloat = 165
    private static let cardImageHeight: CGFloat = 165 / 0.714        // MTG aspect ≈ 0.714
    private static let compactSheetHeight: CGFloat = cardImageHeight + 96
    /// Resolved names cached for the session so re-reading a card never re-hits the network.
    @State private var cache: [String: CardJSON] = [:]
    /// Toggled to force-restart the scanner when the watchdog detects it has frozen.
    @State private var scannerResetToken: Bool = false
    /// Timestamp of the last received scan candidate — used by the watchdog.
    @State private var lastCandidateTime: Date = .now

    var body: some View {
        ZStack {
            // full-bleed camera layer (ignores safe area)
            GeometryReader { geo in
                let card = cardRect(in: geo.size)
                let name = nameRect(in: card)

                ZStack {
                    DataScannerView(onCandidate: { ingest($0) },
                                    cardRect: card,
                                    isScanning: isScanning,
                                    resetToken: scannerResetToken)

                    GuideOverlay(cardRect: card, nameRect: name)

                    // Confidence ring — fills as the same card is held steady, then locks in.
                    // This is the only on-screen feedback; the guide outline + ring say it all.
                    if detected == nil, lockProgress > 0.001 {
                        LockRing(progress: lockProgress)
                            .frame(width: 66, height: 66)
                            .position(x: card.midX, y: card.midY)
                            .allowsHitTesting(false)
                    }
                }
            }
            .ignoresSafeArea()
            .task {
                // Watchdog: if the scanner is active but hasn't emitted a candidate in 4 s it has
                // likely frozen (highlights visible but no callbacks). Toggle the reset token to
                // stop + restart the DataScannerViewController, clearing the stuck state silently.
                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 4_000_000_000)
                    guard isScanning, detected == nil else { continue }
                    if Date.now.timeIntervalSince(lastCandidateTime) >= 4 {
                        scannerResetToken.toggle()
                        lastCandidateTime = .now   // avoid rapid re-triggers
                    }
                }
            }

            // controls layer — a sibling that respects the safe area. No status text: the guide
            // outline and the confidence ring are the only feedback the user needs.
            VStack(spacing: 10) {
                header                 // torch + close, top-right
                Spacer()
                HStack {
                    Spacer()
                    historyButton      // scan history, bottom-right
                }
            }
            .padding()
        }
        .onDisappear { Torch.set(false) }   // never leave the flashlight on after closing
        .fullScreenCover(isPresented: $showHistory, onDismiss: { isScanning = detected == nil }) {
            ScanHistorySheet()
                .environment(\.appTint, tint)
                .environment(\.appCurrency, currency)
                .tint(tint)
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
        .sheet(item: $detected, onDismiss: {
            isScanning = true
            lastResolved = ""        // let the next scan re-resolve, even if it's the same name
            sheetDetent = .height(Self.compactSheetHeight)
            printings = []
            resetLock()
        }) { json in
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
        HStack(spacing: 12) {
            Spacer()

            // Torch — only shown on devices with a controllable flash (the main low-light win).
            if torchAvailable {
                Button {
                    torchOn.toggle()
                    Torch.set(torchOn)
                    HapticManager.light()
                } label: {
                    Image(systemName: torchOn ? "bolt.fill" : "bolt.slash.fill")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(torchOn ? .yellow : .white)
                        .frame(width: 38, height: 38)
                        .background(.black.opacity(0.45), in: Circle())
                        .shadow(radius: 4)
                }
            }

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

    /// Opens the full-screen scan history. Pauses scanning while it's up so nothing resolves behind it.
    private var historyButton: some View {
        Button {
            isScanning = false
            showHistory = true
        } label: {
            Image(systemName: "clock.arrow.circlepath")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 46, height: 46)
                .background(.black.opacity(0.45), in: Circle())
                .shadow(radius: 4)
        }
    }

    /// The detected card as a dismissible sheet: a card-grid preview at medium, expanding to the
    /// full CardInfoView detail screen when pulled up to large.
    private func resultSheet(_ card: Card) -> some View {
        Group {
            if sheetDetent == .large {
                CardInfoView(card: card)
            } else {
                compactPreview(card)
            }
        }
        // Fixed compact height (see `compactSheetHeight`) — no live measurement, so the sheet can't
        // collapse to a sliver while the card art is still loading.
        .presentationDetents([.height(Self.compactSheetHeight), .large], selection: $sheetDetent)
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $showPrintingPicker) {
            PrintingPickerSheet(printings: printings, loading: loadingPrintings)
                .environment(\.appTint, tint)
                .environment(\.appCurrency, currency)
                .tint(tint)
        }
    }

    /// The compact card preview (image + info beside it). The info column is one line per row, so the
    /// layout is the same height for every card.
    private func compactPreview(_ card: Card) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 14) {
                // card image with the add control on top, like the search results — fixed size so it
                // can never collapse small while the art loads.
                ZStack(alignment: .topLeading) {
                    CardGridView(card: card, showPreviews: false)
                    Menu {
                        CollectionControllWidget(card: card)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(tint)
                            .cornerRadius(5)
                            .bold()
                            .shadow(radius: 4)
                    }
                    .padding(8)
                }
                .frame(width: Self.cardImageWidth, height: Self.cardImageHeight)

                // info column hugging the card, centred to its height
                cardInfo(card)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()

            Text("Pull up for full details")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom)
        }
    }

    /// The right-hand info column shown beside the card image at the medium detent.
    @ViewBuilder
    private func cardInfo(_ card: Card) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(card.name)
                .font(.title3.bold())
                .lineLimit(1)
                .truncationMode(.tail)

            if !card.manaCost.isEmpty {
                ManaCostView(cost: card.manaCost, symbolSize: 18)
            }

            Text(card.typeLine)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)

            // Tappable printing row — set symbol + name + collector number / rarity. Tapping opens
            // the picker so the user can correct the printing when the scan guessed wrong.
            Button {
                loadPrintingsIfNeeded()
                showPrintingPicker = true
            } label: {
                HStack(spacing: 8) {
                    SetIconWidget(set: card.set, rarity: card.rarity, maxWidth: 26)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(card.setName.isEmpty ? card.set.uppercased() : card.setName)
                            .font(.caption.bold())
                            .lineLimit(1)
                        Text("#\(card.collectorNumber) · \(card.rarity.capitalized)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 4)
                    if loadingPrintings {
                        ProgressView().controlSize(.mini)
                    } else {
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .tint(.primary)

            Text("Wrong printing? Tap to choose.")
                .font(.caption2)
                .foregroundStyle(.secondary)

            HStack(spacing: 6) {
                ForEach(currency.cardPrices(card.prices), id: \.finish) { item in
                    GridPriceWidget(finish: item.finish, price: item.price)
                }
            }
        }
    }

    /// Pause scanning and present the resolved card (compact first). `printings` is intentionally
    /// left as-is — the scoring fallback may have populated it, which makes the picker open instantly.
    /// It's cleared on the next scan (in `resolveLocked`) and when the sheet dismisses.
    private func present(_ card: CardJSON, key: String) {
        lastResolved = key
        noMatch = false
        isScanning = false
        sheetDetent = .height(Self.compactSheetHeight)
        detected = card
        ScanHistoryStore.add(card)      // record it in the scan history
        resetLock()
    }

    // MARK: Lock

    /// Feed every live frame through the confidence gate. A card has to be read consistently for
    /// `lockDuration` before it resolves, so a single shaky frame can't fire a budget-spending
    /// lookup. Printing hints (set code, collector number, artist) are merged across the whole lock
    /// window, since different frames pick up different parts of the bottom line.
    private func ingest(_ raw: ScanCandidate) {
        let name = cleanName(raw.name)
        let hasName = name.count >= 3
        let hasPrinting = raw.setCode != nil && raw.collectorNumber != nil
        // Need either a readable name or a full printing (set + collector) to act on. The second case
        // is full-art / showcase cards whose title can't be OCR'd but whose bottom line is intact.
        guard hasName || hasPrinting else { return }
        lastCandidateTime = .now                 // feed the freeze watchdog
        guard detected == nil, !isResolving else { return }   // already showing / resolving

        var c = raw
        c.name = hasName ? name : ""
        // Lock identity + status label: the name when we have one, else the scanned printing.
        let key = hasName ? nameKey(name) : "\(raw.setCode!)/\(raw.collectorNumber!)"
        let display = hasName ? name : "\(raw.setCode!.uppercased()) #\(raw.collectorNumber!)"

        // Explicit tap — skip the hold and resolve straight away (printing is correctable after).
        if raw.isManual {
            lockKey = key
            lockCandidate = c
            lockStart = nil
            candidate = display
            noMatch = false
            resolveLocked()
            return
        }

        if key == lockKey, let existing = lockCandidate {
            // Same card persisting — accumulate any extra printing hints this frame read.
            lockCandidate = mergeHints(existing, c)
        } else {
            // A different card entered the frame — start a fresh lock.
            lockKey = key
            lockCandidate = c
            lockStart = .now
            candidate = display
            noMatch = false
        }
        if candidate != display { candidate = display }

        // Advance the ring; resolve once the card has been held long enough.
        guard let start = lockStart else { return }
        let elapsed = Date.now.timeIntervalSince(start)
        withAnimation(.linear(duration: 0.08)) {
            lockProgress = min(1, elapsed / lockDuration)
        }
        if elapsed >= lockDuration { resolveLocked() }
    }

    /// Clear the in-progress lock (without touching what's already presented).
    private func resetLock() {
        lockKey = ""
        lockCandidate = nil
        lockStart = nil
        withAnimation(.easeOut(duration: 0.2)) { lockProgress = 0 }
    }

    /// Merge printing hints from a new frame into the accumulated candidate, keeping the established
    /// name and the first non-nil value read for each field.
    private func mergeHints(_ base: ScanCandidate, _ next: ScanCandidate) -> ScanCandidate {
        var m = base
        m.setCode = base.setCode ?? next.setCode
        m.collectorNumber = base.collectorNumber ?? next.collectorNumber
        m.artist = base.artist ?? next.artist
        // Accumulate the distinct bottom-line reads seen across the lock window (diagnostics).
        for line in next.rawBottomLines where !m.rawBottomLines.contains(line) {
            m.rawBottomLines.append(line)
        }
        return m
    }

    // MARK: Resolve

    /// Resolve the locked candidate. The **name is the anchor** — a fuzzy name match identifies the
    /// card (the reliable ~90% signal). The scanned set code + collector number are only used to
    /// *refine* to the exact printing, and only when that printing is the **same card** — never to
    /// override the name. (A bare set/number lookup ignores the name, so a misread bottom line would
    /// otherwise surface a completely unrelated card.) Any remaining wrong-printing case is the user's
    /// to fix via the printing picker. Skips repeats, caches hits.
    private func resolveLocked() {
        guard !isResolving, let c = lockCandidate else { return }
        let key = c.key
        if key == lastResolved { resetLock(); return }

        isResolving = true       // synchronous latch — blocks re-entry and shows the search spinner
        lockStart = nil          // stop the ring re-triggering this same lock

        resolveTask?.cancel()
        resolveTask = Task {
            defer { isResolving = false }

            // cache hit — no request, doesn't spend the daily budget (already counted)
            if let cached = cache[key] {
                HapticManager.medium()
                present(cached, key: key)
                return
            }

            printings = []                          // fresh scan — drop any cached picker list
            let ocrName = c.name                     // may be empty (full-art / showcase cards)
            let hasName = ocrName.count >= 3
            var card: CardJSON?

            // 1. BOTTOM-PRIORITY — set + collector pins the exact printing on its own, name or not.
            //    This is the workhorse path: the bottom info is present and clean ~99.9% of the time.
            //    When a name was also read, it's used only as a *free* sanity check — if it flatly
            //    disagrees with the looked-up card (a misread bottom), we fall through to the name.
            if let set = c.setCode, let num = c.collectorNumber,
               let exact = await SFAPI.fetchCard(set: set, number: num),
               !hasName || namesAgree(ocrName, exact.name) {
                card = exact
            }

            // 2. NAME FALLBACK — only when the bottom couldn't pin a printing (no pair, lookup failed,
            //    or the name disagreed). Fuzzy-match the name, then score the real printings against
            //    whatever partial signals we did read.
            if card == nil, hasName {
                let anchor = await SFAPI.fetchCardNamed(fuzzy: ocrName)
                card = anchor
                if let anchor, let oracle = anchor.oracleID, !oracle.isEmpty, hasPrintingSignal(c) {
                    let prints = await SFAPI.fetchPrintings(oracleID: oracle)
                    printings = prints              // instant picker for these hard cards
                    if let best = bestPrinting(among: prints, candidate: c), sameCard(best.card, anchor) {
                        card = best.card
                    }
                }
            }

            if let card {
                cache[key] = card
                // Free tier: a scan is only spent on a *real, presented* card. Gate here — after we
                // have one — so a no-match or stray frame never paywalls a user who's out of scans,
                // and a wrong/random result can't burn their budget.
                if !pro.isPro && ScanLimit.remainingToday() <= 0 {
                    isScanning = false
                    showPaywall = true
                    resetLock()
                    return
                }
                if !pro.isPro {
                    ScanLimit.record()              // spend one scan for this newly identified card
                    remaining = ScanLimit.remainingToday()
                }
                HapticManager.medium()              // satisfying "locked on" tap
                present(card, key: key)
            } else {
                // Buzz once on the transition into "no match" so a continuously-failing frame
                // doesn't fire the haptic every pass; let the next stable read try again.
                if !noMatch { HapticManager.error() }
                noMatch = true
                resetLock()
            }
        }
    }

    /// Load every printing of the currently-shown card (newest first) for the picker, lazily — only
    /// when the user first opens it, so a scan the user never corrects costs no extra request.
    private func loadPrintingsIfNeeded() {
        guard printings.isEmpty, !loadingPrintings,
              let oracle = detected?.oracleID, !oracle.isEmpty else { return }
        loadingPrintings = true
        Task {
            let result = await SFAPI.fetchPrintings(oracleID: oracle)
            printings = result
            loadingPrintings = false
        }
    }

    // MARK: OCR cleanup

    /// Clean a raw OCR line into a card name: normalise curly punctuation, drop stray glyphs (mana
    /// pips, symbols the recogniser invents on stylised/old frames), and collapse whitespace. This
    /// gives Scryfall's fuzzy match a far cleaner string, which is what helps older / special-art
    /// cards resolve at all.
    private func cleanName(_ raw: String) -> String {
        let allowed = CharacterSet.letters
            .union(.decimalDigits)            // some names carry numbers ("Borrowing 100,000 Arrows")
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "'-,./&+"))
        let normalised = raw
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "–", with: "-")
            .replacingOccurrences(of: "—", with: "-")
        let kept = String(normalised.unicodeScalars.filter { allowed.contains($0) })
        return kept
            .split(whereSeparator: { $0 == " " || $0 == "\n" })
            .joined(separator: " ")
            .trimmingCharacters(in: CharacterSet(charactersIn: " -,./&"))
    }

    /// A loose key for comparing two reads of the same name across frames — lowercased letters only,
    /// so flickering punctuation/glyphs don't reset an in-progress lock.
    private func nameKey(_ name: String) -> String {
        String(name.lowercased().unicodeScalars.filter { CharacterSet.letters.contains($0) })
    }

    /// Whether two resolved cards are the same card, so a scanned printing can safely replace the
    /// name anchor. Prefers `oracle_id`; falls back to a normalised name compare.
    private func sameCard(_ a: CardJSON, _ b: CardJSON) -> Bool {
        if let oa = a.oracleID, let ob = b.oracleID, !oa.isEmpty, !ob.isEmpty { return oa == ob }
        return nameKey(a.name) == nameKey(b.name)
    }

    /// A *lenient* check that an OCR'd name and a looked-up card name plausibly refer to the same
    /// card — they share at least one significant word. Used only to catch a gross mismatch (the
    /// bottom set/collector was misread into an unrelated card), while tolerating minor OCR slips in
    /// the title. Empty/short names can't tell, so they pass.
    private func namesAgree(_ ocr: String, _ resolved: String) -> Bool {
        func words(_ s: String) -> Set<String> {
            Set(s.lowercased().split(separator: " ").map { nameKey(String($0)) }.filter { $0.count >= 3 })
        }
        let a = words(ocr), b = words(resolved)
        guard !a.isEmpty, !b.isEmpty else { return true }
        return !a.isDisjoint(with: b)
    }

    // MARK: Printing scoring

    /// Minimum score for a scored printing to be trusted, and the margin it must beat the runner-up
    /// by — together they stop a weak/ambiguous match (e.g. one of a basic land's hundreds of
    /// printings) from overriding the safe name-anchor default.
    private static let scoreFloor = 3
    private static let scoreMargin = 2

    /// Whether the candidate carries *any* printing-distinguishing signal worth scoring against. Old
    /// cards print no set code but do carry a year (copyright), artist and collector number.
    private func hasPrintingSignal(_ c: ScanCandidate) -> Bool {
        c.setCode != nil || c.collectorNumber != nil || c.artist != nil
            || !extractYears(c.rawBottomLines.joined(separator: " ")).isEmpty
    }

    /// Pick the printing that best matches the OCR, scoring only the fields that *distinguish*
    /// printings (collector number, release year, set code, artist, set name). Returns the top
    /// printing only when it clears the floor and beats the runner-up by the margin.
    private func bestPrinting(among prints: [CardJSON], candidate c: ScanCandidate) -> (card: CardJSON, score: Int)? {
        guard !prints.isEmpty else { return nil }
        let raw = c.rawBottomLines.joined(separator: " ").lowercased()
        let tokenSet = Set(c.rawBottomLines
            .flatMap { $0.split { scannerTokenSeparators.contains($0) } }
            .map { $0.lowercased().filter { $0.isLetter || $0.isNumber } }
            .filter { !$0.isEmpty })
        let years = extractYears(raw)

        // Normalised collector number the parser settled on (if any) — used to reject printings whose
        // collector clearly contradicts it (so a year/artist match can't rescue the wrong printing).
        let parsedCN = c.collectorNumber.map { String(Int($0.filter(\.isNumber)) ?? -1) }

        let scored = prints
            .map { p -> (card: CardJSON, score: Int, hard: Bool) in
                let r = scorePrinting(p, raw: raw, tokens: tokenSet, years: years, parsedCN: parsedCN)
                return (p, r.score, r.hard)
            }
            .sorted { $0.score > $1.score }

        // The winner is the highest-scoring printing carrying a *hard* signal — a collector/set match,
        // or a year+artist match (which is what lets a set-code-less old card resolve to its real
        // era instead of a modern reprint). It must clear the floor and beat the next *distinct*
        // printing by the margin, so genuinely ambiguous ties (same year/#/artist, different set) fall
        // back rather than guess.
        guard let top = scored.first(where: { $0.hard }), top.score >= Self.scoreFloor else { return nil }
        let runnerUp = scored.first { $0.card.id != top.card.id }?.score ?? 0
        guard top.score - runnerUp >= Self.scoreMargin else { return nil }
        return (top.card, top.score)
    }

    /// Score one printing against the OCR token bag. `hard` marks a trustworthy identity match: a
    /// collector number, a set code, or a year **and** artist match together (the discriminator for
    /// old cards). A year/artist match is *not* hard if the printing's collector contradicts a
    /// collector number we actually read.
    private func scorePrinting(_ p: CardJSON, raw: String, tokens: Set<String>,
                               years: Set<Int>, parsedCN: String?) -> (score: Int, hard: Bool) {
        var s = 0
        var hard = false
        // Collector number — strongest. Substring-tolerant so OCR digit-doubling ("44174" ⊇ "174") hits.
        var collectorContradicts = false
        if let cn = p.collectorNumber {
            let digits = cn.filter(\.isNumber)
            if !digits.isEmpty {
                let bare = String(Int(digits) ?? -1)            // normalise "0174" → "174"
                if tokens.contains(digits) || tokens.contains(bare)
                    || (bare.count >= 2 && raw.contains(bare)) {
                    s += 3; hard = true
                } else if let parsedCN, parsedCN != bare {
                    collectorContradicts = true                 // we read a number; this isn't it
                }
            }
        }
        // Set code — exact token match (short codes would false-hit as substrings).
        if let set = p.set?.lowercased(), tokens.contains(set) { s += 3; hard = true }
        // Release year — copyright range on old cards yields the print year via the max year matched.
        var yearMatch = false
        if let released = p.releasedAt, let y = Int(released.prefix(4)), years.contains(y) {
            s += 2; yearMatch = true
        }
        // Artist — all words present (substring-tolerant for OCR noise around the name).
        var artistMatch = false
        if let artist = p.artist {
            let words = artist.lowercased().split(separator: " ").map(String.init).filter { $0.count >= 3 }
            if !words.isEmpty, words.allSatisfy({ w in raw.contains(w) }) { s += 2; artistMatch = true }
        }
        // Set name — any significant word present.
        if let sn = p.setName?.lowercased() {
            let words = sn.split(separator: " ").map(String.init).filter { $0.count >= 4 }
            if words.contains(where: { raw.contains($0) }) { s += 1 }
        }
        // Year + artist together is a hard signal for set-code-less old cards — unless the collector
        // contradicts what we read (that means this is the wrong printing of the right card).
        if yearMatch && artistMatch && !collectorContradicts { hard = true }
        return (s, hard)
    }

    /// All four-digit years (1900s/2000s) in a string — used to read a card's copyright year(s).
    private func extractYears(_ text: String) -> Set<Int> {
        var years = Set<Int>()
        guard let re = try? NSRegularExpression(pattern: #"(?:19|20)\d{2}"#) else { return years }
        let ns = text as NSString
        re.enumerateMatches(in: text, range: NSRange(location: 0, length: ns.length)) { m, _, _ in
            if let m, let y = Int(ns.substring(with: m.range)) { years.insert(y) }
        }
        return years
    }
}

// MARK: Lock Ring

/// A camera-overlay ring that fills as a card is held steady, signalling the confidence lock.
private struct LockRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.25), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Image(systemName: "viewfinder")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
        }
        .shadow(color: .black.opacity(0.4), radius: 4)
    }
}

// MARK: Printing Picker

/// Every printing of a scanned card, shown as the same card grid the Search tab uses — image, price
/// and add controls per printing — so the user can add the exact copy they own. The direct answer to
/// "it always gives me the newest Sol Ring" when the printing can't be OCR'd.
private struct PrintingPickerSheet: View {
    let printings: [CardJSON]
    let loading: Bool

    @Environment(\.dismiss) private var dismiss

    private let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]

    var body: some View {
        NavigationStack {
            Group {
                if loading && printings.isEmpty {
                    ProgressView("Loading printings…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if printings.isEmpty {
                    ContentUnavailableView("No printings found", systemImage: "rectangle.on.rectangle")
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(printings) { printing in
                                SearchCardView(card: SFAPI.JSONtoModel(json: printing))
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Choose Printing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: Scan History

/// Persistent record of recently scanned cards, newest first. Stored as JSON in Application Support
/// so it survives app launches. A rolling window of the most recent `maxItems`: each new scan goes
/// to the front and the oldest drops off the end, so the cache never grows unbounded. Only touched
/// from the main thread (the scanner's resolve + the history sheet).
enum ScanHistoryStore {
    private static let maxItems = 25
    private static let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("scanHistory.json")
    }()

    /// The scan history, newest first.
    static private(set) var cards: [CardJSON] = load()

    /// Record a presented card (de-duped by Scryfall id, moved to the front).
    static func add(_ card: CardJSON) {
        if let id = card.id { cards.removeAll { $0.id == id } }
        cards.insert(card, at: 0)
        if cards.count > maxItems { cards = Array(cards.prefix(maxItems)) }
        save()
    }

    static func clear() {
        cards = []
        save()
    }

    private static func load() -> [CardJSON] {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([CardJSON].self, from: data) else { return [] }
        return decoded
    }

    private static func save() {
        try? FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(),
                                                 withIntermediateDirectories: true)
        if let data = try? JSONEncoder().encode(cards) { try? data.write(to: fileURL) }
    }
}

/// Full-screen scan history: every card the scanner has presented, shown as the same card grid the
/// Search tab and printing picker use (image, price, add controls, tap for full info).
private struct ScanHistorySheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cards: [CardJSON] = []

    private let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]

    var body: some View {
        NavigationStack {
            Group {
                if cards.isEmpty {
                    ContentUnavailableView("No scans yet", systemImage: "clock.arrow.circlepath",
                                           description: Text("Cards you scan will show up here."))
                } else {
                    ScrollView {
                        Text("Your 25 most recent scans. Older ones drop off as you scan more.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.top, 10)

                        LazyVGrid(columns: columns) {
                            ForEach(cards) { card in
                                SearchCardView(card: SFAPI.JSONtoModel(json: card))
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !cards.isEmpty {
                        Button("Clear", role: .destructive) {
                            ScanHistoryStore.clear()
                            cards = []
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear { cards = ScanHistoryStore.cards }
    }
}

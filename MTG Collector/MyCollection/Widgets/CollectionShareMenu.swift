//
//  CollectionShareMenu.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Toolbar menu for a deck or binder: share a Universal Link (CloudKit snapshot), export a
//      .txt / .csv file, or import cards from text/CSV. All three are Pro features and present the
//      paywall when locked. Self-contained — owns its own sheets and state — so DeckView and
//      BinderView just drop it into their toolbar.
//  External Types:
//      ImportTarget, CollectionSnapshotFactory, CollectionShareService, CollectionExporter,
//      CollectionImportBuilder, ProAccessManager, PaywallView, ImportCardsSheet
//

// MARK: Imports

import SwiftUI
import SwiftData
import UIKit

// MARK: Menu

struct CollectionShareMenu: View {

    let target: ImportTarget
    /// Toolbar use shows just the share icon; set `false` to render a labelled "Share" row (e.g. as
    /// a submenu inside a context menu).
    var compact: Bool = true

    @Environment(\.modelContext) private var modelContext
    @Environment(ProAccessManager.self) private var pro

    /// Paywall and import are normal SwiftUI sheets. The share sheet is NOT — a
    /// UIActivityViewController can't be embedded in a `.sheet` (it presents itself, which shows an
    /// empty sheet), so it's presented imperatively from the top view controller instead.
    private enum ActiveSheet: Int, Identifiable {
        case paywall, importCards
        var id: Int { rawValue }
    }
    @State private var activeSheet: ActiveSheet?
    @State private var isPreparing = false
    @State private var errorMessage: String?

    var body: some View {
        Menu {
            Button("Share Link", systemImage: "square.and.arrow.up") {
                gated { Task { await shareLink() } }
            }
            Menu {
                Button("Text (.txt)") { gated { exportFile(.text) } }
                Button("CSV (.csv)") { gated { exportFile(.csv) } }
            } label: {
                Label("Export File", systemImage: "doc.text")
            }
            Divider()
            Button("Import Cards", systemImage: "square.and.arrow.down") {
                gated { activeSheet = .importCards }
            }
        } label: {
            if isPreparing {
                ProgressView()
            } else if compact {
                Image(systemName: "square.and.arrow.up")
            } else {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .paywall:     PaywallView()
            case .importCards: ImportCardsSheet(target: target)
            }
        }
        .alert("Share Failed", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    // MARK: Gating

    /// Run a Pro action, or present the paywall if the user isn't entitled.
    private func gated(_ action: () -> Void) {
        if pro.isPro { action() } else { activeSheet = .paywall }
    }

    // MARK: Share link

    private func shareLink() async {
        isPreparing = true
        defer { isPreparing = false }

        let (snapshot, cover): (CollectionSnapshot, UIImage?)
        switch target {
        case .deck(let deck):     (snapshot, cover) = CollectionSnapshotFactory.make(from: deck)
        case .binder(let binder): (snapshot, cover) = CollectionSnapshotFactory.make(from: binder)
        }

        do {
            let url = try await CollectionShareService.publish(snapshot, cover: cover)
            presentShareSheet(items: [url])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: Export file

    private func exportFile(_ format: ImportFormat) {
        let rows: [ExportRow]
        let name: String
        switch target {
        case .deck(let deck):
            rows = CollectionImportBuilder.exportRows(for: deck, context: modelContext)
            name = deck.name
        case .binder(let binder):
            rows = CollectionImportBuilder.exportRows(for: binder, context: modelContext)
            name = binder.name
        }

        let contents: String
        let ext: String
        switch format {
        case .text: contents = CollectionExporter.text(rows: rows); ext = "txt"
        case .csv:  contents = CollectionExporter.csv(rows: rows);  ext = "csv"
        }

        guard let url = writeTempFile(name: name, ext: ext, contents: contents) else { return }
        presentShareSheet(items: [url])
    }

    // MARK: Share-sheet presentation

    /// Present a UIActivityViewController from the top-most view controller. Done imperatively
    /// (not via SwiftUI `.sheet`) because UIActivityViewController presents itself — embedding it
    /// in a sheet yields an empty sheet. Deferred a runloop so the tapped menu finishes dismissing.
    @MainActor
    private func presentShareSheet(items: [Any]) {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                  let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                return
            }
            var top = root
            while let presented = top.presentedViewController { top = presented }

            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            // iPad needs a source for the popover anchor.
            if let pop = vc.popoverPresentationController {
                pop.sourceView = top.view
                pop.sourceRect = CGRect(x: top.view.bounds.midX, y: top.view.bounds.maxY - 40, width: 0, height: 0)
                pop.permittedArrowDirections = []
            }
            top.present(vc, animated: true)
        }
    }

    private func writeTempFile(name: String, ext: String, contents: String) -> URL? {
        let safe = name.isEmpty ? "Cardhold" : name
            .components(separatedBy: CharacterSet(charactersIn: "/\\:?%*|\"<>")).joined()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(safe).\(ext)")
        do {
            try contents.data(using: .utf8)?.write(to: url)
            return url
        } catch {
            errorMessage = "Couldn't create the export file."
            return nil
        }
    }
}

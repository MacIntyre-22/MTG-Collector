//
//  CardScanner.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Live card-name scanner using VisionKit's DataScannerViewController. Highlights text in the
//      camera feed; tapping a highlighted name returns its transcript so the caller can search for
//      it. Separate from CameraPicker (which is for photo capture). Gate the entry point on
//      `DataScannerViewController.isSupported` — see SearchTabView.
//  External Types:
//      (none)
//

// MARK: Imports

import SwiftUI
import VisionKit

// MARK: Scanner Representable

struct DataScannerView: UIViewControllerRepresentable {

    var onScan: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ scanner: DataScannerViewController, context: Context) {
        try? scanner.startScanning()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onScan: onScan)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let onScan: (String) -> Void
        init(onScan: @escaping (String) -> Void) { self.onScan = onScan }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case let .text(text) = item {
                onScan(text.transcript)
            }
        }
    }
}

// MARK: Scanner Sheet

struct CardScannerSheet: View {

    /// Called with the tapped card name; the caller dismisses + searches.
    var onScan: (String) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            DataScannerView(onScan: onScan)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                HStack {
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

                Text("Point at a card name and tap it")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.black.opacity(0.45), in: Capsule())
            }
            .padding()
        }
    }
}

//
//  NewBinderSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Allows the user to create a new binder instance, optionally importing a card list (pasted,
//      a picked .txt / .csv, or a file opened from Files and routed here). Reuses the deck-import
//      engine (parse → resolve) and CollectionImportBuilder to fill the new binder's flat card list.
//  External Types:
//      Binder, ImageManager, CameraPicker, PhotoLibraryPicker, Spotlight, DeckImportViewModel,
//      DeckImportReviewView, CollectionImportBuilder, CardStore
//

// MARK: Imports

import SwiftUI
import UniformTypeIdentifiers

// MARK: Types

struct NewBinderSheet: View {

    // MARK: Stored Properties

    /// Optional card list to pre-load (e.g. a .txt / .csv opened from Files and routed here).
    var initialImportText: String = ""

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Environment(ProAccessManager.self) private var pro
    @State private var showPaywall = false
    @State private var name: String = ""
    @State var selectedImage: UIImage?
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false

    @StateObject private var importVM = DeckImportViewModel()
    @State private var isCreating = false
    @State private var showReview = false
    @State private var showFileImporter = false

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                Section("Binder Information") {
                    VStack(alignment: .center, spacing: 20) {
                        ZStack(alignment: .center) {
                            Color.gray
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            Image(uiImage: selectedImage ?? UIImage(named: "CardholdIcon")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)

                            Image(systemName: "camera.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                                .onTapGesture(count: 1, perform: {
                                    showSourceSelection.toggle()
                                })
                        }
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                }

                Section("Import Cards (Optional)") {
                    if pro.isPro {
                        ZStack(alignment: .topLeading) {
                            if importVM.rawText.isEmpty {
                                Text("Paste a card list…\n4 Lightning Bolt\n2 Counterspell\n\nor a CSV export…")
                                    .foregroundStyle(.secondary)
                                    .font(.callout)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                            TextEditor(text: $importVM.rawText)
                                .frame(minHeight: 140)
                                .onChange(of: importVM.rawText) { _, _ in
                                    importVM.parse()
                                }
                        }

                        Button {
                            showFileImporter = true
                        } label: {
                            Label("Import .txt / .csv File", systemImage: "doc.text")
                        }

                        if !importVM.parsedLines.isEmpty {
                            HStack {
                                Text("Cards")
                                Spacer()
                                Text("\(importVM.parsedLines.reduce(0) { $0 + $1.quantity })")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.caption)
                        }
                    } else {
                        ProUpgradeButton(
                            title: "Import is a Pro feature",
                            message: "Upgrade to build binders from a text or .csv list."
                        ) { showPaywall = true }
                    }
                }
            }
            .navigationTitle("New Binder")
            .onAppear {
                // Seed a list opened from Files (parse fires via the editor's onChange). The file
                // flow is Pro-gated upstream; guard here too so import stays Pro-only.
                if pro.isPro, importVM.rawText.isEmpty, !initialImportText.isEmpty {
                    importVM.rawText = initialImportText
                    importVM.parse()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isCreating)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isCreating {
                        ProgressView()
                    } else {
                        Button(hasImport ? "Review" : "Create") {
                            Task { await startCreate() }
                        }
                        .disabled(name.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showReview) {
                DeckImportReviewView(importVM: importVM) {
                    Task { await commitImport() }
                }
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.plainText, .commaSeparatedText, .text],
                allowsMultipleSelection: false
            ) { result in
                loadImportFile(result)
            }
            .confirmationDialog("Select Source",isPresented: $showSourceSelection, actions:{
                Button("Camera"){
                    photoSource = .camera
                    showImagePicker.toggle()
                }
                Button("Photo Library"){
                    photoSource = .photoLibrary
                    showImagePicker.toggle()
                }
            }
            )
            .fullScreenCover(isPresented: $showImagePicker) {
                if photoSource == .camera{
                    CameraPicker(image: $selectedImage)
                        .ignoresSafeArea()
                } else {
                    PhotoLibraryPicker(image: $selectedImage)
                }
            }
        }
    }

    // MARK: Derived

    /// Whether the user has entered any list text to import.
    private var hasImport: Bool {
        !importVM.rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: Create flow

    /// Create immediately when there's no import; otherwise resolve and open the review screen.
    private func startCreate() async {
        guard hasImport else {
            buildBinder(resolved: [])
            dismiss()
            return
        }
        isCreating = true
        await importVM.resolve()
        isCreating = false
        showReview = true
    }

    /// Called from the review screen's confirm — build the binder with whatever resolved.
    private func commitImport() async {
        buildBinder(resolved: importVM.result.resolved)
        dismiss()
    }

    /// Create the Binder record and fill it from the resolved import cards.
    private func buildBinder(resolved: [ResolvedDeckCard]) {
        let binder = Binder(name: name, notes: "")
        binder.setCover(selectedImage)

        Spotlight.index(kind: .binder, id: binder.id, name: binder.name,
                        image: binder.coverUIImage, description: "Binder in your collection.")
        modelContext.insert(binder)

        guard !resolved.isEmpty else { return }
        CollectionImportBuilder.add(resolved, to: binder, context: modelContext)
        let ids = resolved.compactMap { $0.card.id }
        Task { await CardStore.prime(ids, context: modelContext) }
        HapticManager.success()
    }

    // MARK: File import

    /// Read a picked .txt / .csv list into the import field and parse it for the live preview.
    private func loadImportFile(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else { return }
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }
        if let text = try? String(contentsOf: url, encoding: .utf8) {
            importVM.rawText = text
            importVM.sourceFilename = url.lastPathComponent
            importVM.parse()
        }
    }
}

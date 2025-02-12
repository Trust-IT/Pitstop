//
//  DocumentCellView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 11/02/25.
//

import SwiftData
import SwiftUI

struct DocumentCellView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(\.modelContext) private var modelContext

    @Query var documents: [Document]
    @State private var selectedDocument: Document = .mock()
    @State private var selectedDocumentType: DocumentPickerType?
    @State private var showDocumentPicker: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var presentImporter = false
    @State private var showPDF = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack {
                Spacer(minLength: 12)
                HStack {
                    ForEach(documents, id: \.uuid) { document in
                        DocumentCell(title: document.title) {
                            selectedDocument = document
                            showPDF.toggle()
                        }
                    }
                    Button(action: {
                        showDocumentPicker.present()
                    }, label: {
                        AddElementView(label: "Add document")
                    })
                }
                Spacer(minLength: 16)
            }
            .fileImporter(
                isPresented: $presentImporter,
                allowedContentTypes: [.pdf]
            ) { result in
                handleFileImport(result: result)
            }
        }
        .safeAreaInset(edge: .trailing, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        .safeAreaInset(edge: .leading, spacing: 0) {
            Spacer()
                .frame(width: 16)
        }
        .fullScreenCover(isPresented: $showPDF) {
            DocumentView(document: $selectedDocument)
        }
        .alert(config: $showDocumentPicker) {
            ConfirmationDialog(
                items: DocumentPickerType.allCases,
                message: "Select how to upload your document",
                onTap: { value in
                    selectedDocumentType = value
                    showDocumentPicker.dismiss()
                },
                onCancel: {
                    selectedDocumentType = nil
                    showDocumentPicker.dismiss()
                }
            )
        }
        .onChange(of: selectedDocumentType) { _, newValue in
            guard let newValue else { return }
            switch newValue {
            case .files:
                presentImporter.toggle()
                selectedDocumentType = nil
            case .photo:
                navManager.push(.docScanner)
                selectedDocumentType = nil
            }
        }
    }

    enum DocumentPickerType: String, CaseIterable, Identifiable {
        var id: Self { self }

        case files = "Files"
        case photo = "Photo"
    }
}

// MARK: METHODS

private extension DocumentCellView {
    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            processSelectedFile(url: url)
        case let .failure(error):
            // TODO: Implement proper error handling
            print("File selection failed: \(error)")
        }
    }

    func processSelectedFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed to access security-scoped resource.")
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let data = try Data(contentsOf: url)
            let documentTitle = url.deletingPathExtension().lastPathComponent

            let newDocument = Document(data: data, title: documentTitle)
            try newDocument.saveToModelContext(context: modelContext)
        } catch {
            // TODO: Implement proper error handling
            print("Error when processing document: \(error)")
        }
    }
}

#Preview {
    DocumentCellView()
        .background(Color.red)
        .environmentObject(VehicleManager())
        .environmentObject(NavigationManager())
        .environment(AppState())
        .environment(SceneDelegate())
}

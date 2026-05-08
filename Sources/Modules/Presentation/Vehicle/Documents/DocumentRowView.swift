//
//  DocumentRowView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 11/02/25.
//

import ChassisUI
import NavigatorUI
import OSLog
import PitstopData
import SwiftUI

struct DocumentRowView: View {
    @Environment(\.navigator) private var navigator
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager

    private var documents: [Document] { vehicleManager.documents }
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
                        Button(action: {
                            selectedDocument = document
                            showPDF.toggle()
                        }, label: {
                            ElementCellView(title: document.title, icon: ChassisUIAsset.documents)
                        })
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
            DocumentContentView(document: $selectedDocument)
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
                navigator.navigate(to: VehicleDestinations.docScanner)
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

private extension DocumentRowView {
    func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case let .success(url):
            processSelectedFile(url: url)
        case let .failure(error):
            // TODO: Implement proper error handling
            Logger.persistence.error("File selection failed: \(error)")
        }
    }

    func processSelectedFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            Logger.persistence.warning("Failed to access security-scoped resource")
            return
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let data = try Data(contentsOf: url)
            let documentTitle = url.deletingPathExtension().lastPathComponent
            let newDocument = Document(data: data, title: documentTitle)
            vehicleManager.addDocument(newDocument)
        } catch {
            // TODO: Implement proper error handling
            Logger.persistence.error("Error when processing document: \(error)")
        }
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    ManagedNavigationStack {
        DocumentRowView()
            .background(Color.red)
            .environment(vehicleManager)
            .environment(AppState())
    }
}

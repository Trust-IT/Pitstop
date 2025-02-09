//
//  DocumentScannerView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 01/02/25.
//

import SwiftData
import SwiftUI

struct DocumentScannerView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(\.modelContext) private var modelContext
    @State private var scannedImages: [UIImage] = []
    @State private var showCameraPicker = false
    let columns = [GridItem(.adaptive(minimum: 100))]

    @State private var renameDocumentAlert: AlertConfig = .init(
        enableBackgroundBlur: false,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var documentTitle: String = PitstopAPPStrings.Common.untitled

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    Button(action: {
                        showCameraPicker.toggle()
                    }, label: {
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 30, height: 25)
                            .background {
                                Rectangle()
                                    .fill(Palette.greyInput.opacity(0.5))
                                    .frame(width: 100, height: 100)
                            }
                            .frame(width: 100, height: 100)
                    })
                    .buttonStyle(.plain)

                    ForEach(scannedImages, id: \.self) { image in
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .border(Palette.black, width: 1)
                                .clipped()
                        }
                    }
                }
                .padding()
            }
            Spacer()
            if !scannedImages.isEmpty {
                Button(PitstopAPPStrings.Common.save) {
                    persistDocument(withTitle: documentTitle)
                }
                .buttonStyle(Primary())
            }
        }
        .padding(.top, 16)
        .background(Palette.greyBackground)
        .navigationTitle(documentTitle)
        .sheet(isPresented: $showCameraPicker) {
            DocumentCameraVCRepresentable(scanResult: $scannedImages)
        }
        .toolbar {
            ToolbarTitleMenu {
                Button(PitstopAPPStrings.Common.rename) {
                    renameDocumentAlert.present()
                }
                .buttonStyle(Primary())
            }
        }
        .alert(config: $renameDocumentAlert) {
            AlertInputView(
                title: PitstopAPPStrings.Document.rename,
                placeholder: PitstopAPPStrings.Document.Rename.placeholder,
                alert: $renameDocumentAlert,
                action: { input in
                    documentTitle = input
                }
            )
        }
    }

    private func persistDocument(withTitle title: String) {
        guard let data = PDFCreator.createPDF(from: scannedImages) else {
            return
        }

        do {
            let document = Document(data: data, title: title)
            try document.saveToModelContext(context: modelContext)
            navManager.pop()
        } catch {
            print("Error when saving document \(error)")
        }
    }
}

#Preview {
    DocumentScannerView()
}

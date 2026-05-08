//
//  DocumentScannerView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 01/02/25.
//

import ChassisUI
import NavigatorUI
import PitstopData
import SwiftUI

struct DocumentScannerView: View {
    @Environment(\.navigator) private var navigator
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager
    @State private var scannedImages: [UIImage] = []
    @State private var showCameraPicker = false
    let columns = [GridItem(.adaptive(minimum: 100))]

    @State private var renameDocumentAlert: AlertConfig = .init(
        enableBackgroundBlur: true,
        disableOutsideTap: false,
        transitionType: .slide
    )

    @State private var documentTitle: String = PitstopStrings.Localizable.Common.untitled

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
                Button(PitstopStrings.Localizable.Common.save) {
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
                Button(PitstopStrings.Localizable.Common.rename) {
                    renameDocumentAlert.present()
                }
                .buttonStyle(Primary())
            }
        }
        .alert(config: $renameDocumentAlert) {
            AlertInputView(
                title: PitstopStrings.Localizable.Document.rename,
                placeholder: PitstopStrings.Localizable.Document.Rename.placeholder,
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
        let document = Document(data: data, title: title)
        vehicleManager.addDocument(document)
        navigator.back()
    }
}

#Preview {
    DocumentScannerView()
}

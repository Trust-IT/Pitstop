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
                    })
                    .buttonStyle(.plain)

                    ForEach(scannedImages, id: \.self) { image in
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                        }
                    }
                }
                .padding()
            }
            Spacer()
            if !scannedImages.isEmpty {
                Button("Save scans as PDF") {
                    // TODO: Add alert to input title
                    persistDocument(withTitle: "RNDM \(Int.random(in: 1 ... 100))")
                }
                .buttonStyle(Primary())
            }
        }
        .padding(.top, 16)
        .background(Palette.greyBackground)
        .navigationTitle("Select Documents")
        .sheet(isPresented: $showCameraPicker) {
            DocumentCameraVCRepresentable(scanResult: $scannedImages)
        }
    }

    private func persistDocument(withTitle title: String) {
        guard let data = PDFCreator.createPDF(from: scannedImages) else {
            return
        }
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(UUID().uuidString + ".pdf")

        do {
            try data.write(to: fileURL)
            let document = Document(data: data, title: title, fileURL: fileURL)
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

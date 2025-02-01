//
//  DocumentScannerView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 01/02/25.
//

import SwiftUI

struct DocumentScannerView: View {
    @State private var scannedImages: [UIImage] = [UIImage(systemName: "pencil")!, UIImage(systemName: "person.crop.circle")!, UIImage(systemName: "photo")!]
    @State private var isShowingVNDocumentCameraView = false
    let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 20) {
                Button(action: {
                    showVNDocumentCameraView()
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
        .background(Palette.greyBackground)
        .navigationTitle("Select Documents")
        .sheet(isPresented: $isShowingVNDocumentCameraView) {
            DocumentCameraVCRepresentable(scanResult: $scannedImages)
        }
    }

    private func showVNDocumentCameraView() {
        isShowingVNDocumentCameraView = true
    }
}

#Preview {
    DocumentScannerView()
}

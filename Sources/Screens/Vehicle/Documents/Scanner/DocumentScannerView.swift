//
//  DocumentScannerView.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 01/02/25.
//

import SwiftUI

struct DocumentScannerView: View {
    @State private var scannedImages: [UIImage] = []
    @State private var showCameraPicker = false
    let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
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
            .padding(.top, 16)
            .padding()
            Spacer()
            if !scannedImages.isEmpty {
                Button("Save scans as PDF") {}
                    .buttonStyle(Primary())
            }
        }
        .background(Palette.greyBackground)
        .navigationTitle("Select Documents")
        .sheet(isPresented: $showCameraPicker) {
            DocumentCameraVCRepresentable(scanResult: $scannedImages)
        }
    }
}

#Preview {
    DocumentScannerView()
}

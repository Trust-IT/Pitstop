//
//  DocumentContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import ChassisUI
import PDFKit
import PitstopData
import SwiftUI

struct DocumentContentView: View {
    @Environment(VehicleManager.self) private var vehicleManager: VehicleManager
    @Binding var document: Document
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack {
                // MARK: For now it handles only data

                PDFRepresentedView(data: document.data)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                Button(action: {
                    dismiss()
                }, label: {
                    Text(PitstopStrings.Localizable.Common.cancel)
                        .font(Typography.headerM)
                })
                .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(document.title)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if let pdf = PDFDocument(document: document) {
                            ShareLink(item: pdf, preview: SharePreview(document.title)) {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .resizable()
                                    .frame(width: 16, height: 22)
                                    .foregroundStyle(Palette.black)
                            }
                        }
                        Button(action: {
                            vehicleManager.deleteDocument(document)
                            dismiss()
                        }, label: {
                            ChassisUIAsset.deleteIcon.swiftUIImage
                                .resizable()
                                .frame(width: 20, height: 22)
                                .foregroundStyle(Palette.black)
                        })
                    }
                }
            }
        }
    }
}

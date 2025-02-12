//
//  DocumentContentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import PDFKit
import SwiftUI

struct DocumentContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var document: Document
    @Environment(\.presentationMode) private var presentationMode
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
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(PitstopAPPStrings.Common.cancel)
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
                    Button(action: {
                        modelContext.delete(document)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(.deleteIcon)
                            .resizable()
                            .frame(width: 20, height: 22)
                            .foregroundStyle(Palette.black)
                    })
                }
            }
        }
    }
}

//
//  DocumentView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 11/06/22.
//

import PDFKit
import SwiftUI

struct DocumentView: View {
    @Binding var document: Document
    @Environment(\.presentationMode) private var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                if let url = document.fileURL {
                    PDFRepresentedView(url)
                }
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
            }
        }
    }
}

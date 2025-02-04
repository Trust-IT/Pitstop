//
//  PDFRepresentedView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//

import PDFKit
import SwiftUI

struct PDFRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context _: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true // Automatically scales content to fit the view

        pdfView.document = PDFDocument(url: url)

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context _: Context) {
        pdfView.document = PDFDocument(url: url)
    }
}

// TODO: Move to a PDF manager
enum PDFCreator {
    static func createPDF(from images: [UIImage]) -> Data? {
        guard !images.isEmpty else { return nil }
        let A4Size = CGRect(x: 0, y: 0, width: 612, height: 792)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: A4Size)
        let data = pdfRenderer.pdfData { context in
            for image in images {
                context.beginPage()
                let imageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
                image.draw(in: imageRect)
            }
        }

        return data
    }
}

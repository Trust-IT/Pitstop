//
//  PDFRepresentedView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/06/22.
//

import PDFKit
import SwiftUI

struct PDFRepresentedView: UIViewRepresentable {
    let url: URL?
    let data: Data?

    init(url: URL? = nil, data: Data? = nil) {
        self.url = url
        self.data = data
    }

    func makeUIView(context _: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true // Automatically scales content to fit the view

        loadDocument(for: pdfView)

        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context _: Context) {
        loadDocument(for: pdfView)
    }

    private func loadDocument(for pdfView: PDFView) {
        if let url {
            if let document = PDFDocument(url: url) {
                pdfView.document = document
            } else {
                print("⚠️ Failed to load PDF from \(url)")
            }
        } else if let data {
            if let document = PDFDocument(data: data) {
                pdfView.document = document
            } else {
                print("⚠️ Failed to load PDF from \(data)")
            }
        }
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

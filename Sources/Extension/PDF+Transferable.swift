//
//  PDF+Transferable.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 13/02/25.
//

import PDFKit
import SwiftUI

extension PDFDocument: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .pdf) { pdf in
            guard let data = pdf.dataRepresentation() else {
                fatalError("Could not create a pdf file")
            }

            var fileURL = FileManager.default.temporaryDirectory

            if let title = pdf.title {
                fileURL = fileURL.appendingPathComponent(title)
            }

            try data.write(to: fileURL)
            return SentTransferredFile(fileURL)
        }
    }
}

public extension PDFDocument {
    var title: String? {
        guard let attributes = documentAttributes,
              let titleAttribute = attributes[PDFDocumentAttribute.titleAttribute]
        else { return nil }

        return titleAttribute as? String
    }
}

extension PDFDocument {
    convenience init?(document: Document) {
        self.init(data: document.data)
        documentAttributes![PDFDocumentAttribute.titleAttribute] = document.title
    }
}

//
//  HTML View.swift
//  Hurricane
//
//  Created by Francesco Puzone on 14/06/22.
//

import Foundation
import OSLog
import SwiftUI

public struct HTMLView: View {
    let htmlFileName: String

    @State private var content: AttributedString = .init()

    public var body: some View {
        ScrollView {
            Text(content)
                .padding()
        }
        .task { load() }
    }

    private func load() {
        guard !htmlFileName.isEmpty else {
            Logger.navigation.warning("HTMLView: empty file name")
            return
        }
        guard let filePath = Bundle.main.path(forResource: htmlFileName, ofType: "html"),
              let htmlData = try? Data(contentsOf: URL(fileURLWithPath: filePath))
        else {
            Logger.navigation.warning("HTMLView: file path not found for \(htmlFileName)")
            return
        }
        do {
            let nsAttr = try NSAttributedString(
                data: htmlData,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            content = AttributedString(nsAttr)
        } catch {
            Logger.navigation.error("HTMLView: failed to load \(htmlFileName): \(error)")
        }
    }
}

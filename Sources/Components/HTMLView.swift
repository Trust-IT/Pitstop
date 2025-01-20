//
//  HTML View.swift
//  Hurricane
//
//  Created by Francesco Puzone on 14/06/22.
//

import Foundation
import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlFileName: String

    func makeUIView(context _: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: UIViewType, context _: Context) {
        uiView.load(htmlFileName)
    }
}

extension WKWebView {
    func load(_ htmlFileName: String) {
        guard !htmlFileName.isEmpty else {
            return print("Empty file name")
        }
        guard let filePath = Bundle.main.path(forResource: htmlFileName, ofType: "html") else {
            return print("Error file path")
        }
        do {
            let htmlString = try String(contentsOfFile: filePath, encoding: .utf8)
            loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: filePath))
        } catch {
            print("HTML error")
        }
    }
}

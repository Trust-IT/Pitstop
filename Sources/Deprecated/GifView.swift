//
//  GifView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 14/06/22.
//

import ImageIO
import SwiftUI

struct GifView: UIViewRepresentable {
    private let name: String
    private let size: CGSize

    init(_ name: String, size: CGSize = CGSize(width: 200, height: 200)) {
        self.name = name
        self.size = size
    }

    func makeUIView(context _: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: .zero, size: size)
        loadGif(into: imageView)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context _: Context) {
        uiView.frame = CGRect(origin: .zero, size: size)
        loadGif(into: uiView)
    }

    private func loadGif(into imageView: UIImageView) {
        if let gifURL = Bundle.main.url(forResource: name, withExtension: "gif") {
            if let gifData = try? Data(contentsOf: gifURL) {
                if let source = CGImageSourceCreateWithData(gifData as CFData, nil) {
                    let count = CGImageSourceGetCount(source)
                    var images = [UIImage]()
                    var duration: TimeInterval = 0

                    // Extract all the frames from the GIF
                    for index in 0 ..< count {
                        if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                            images.append(UIImage(cgImage: cgImage))
                            if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
                               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                               let frameDuration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval {
                                duration += frameDuration
                            }
                        }
                    }

                    if !images.isEmpty {
                        imageView.animationImages = images
                        imageView.animationDuration = duration
                        imageView.animationRepeatCount = 0
                        imageView.startAnimating()
                    }
                }
            }
        }
    }
}

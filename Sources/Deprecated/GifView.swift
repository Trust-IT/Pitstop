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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(origin: .zero, size: size)
        loadGif(into: imageView)
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context _: Context) {
        uiView.contentMode = .scaleAspectFit
        uiView.clipsToBounds = true
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

                    for index in 0 ..< count {
                        if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                            var frameImage = UIImage(cgImage: cgImage)
                            frameImage = resizeImage(image: frameImage, targetSize: size) // Resize each frame
                            images.append(frameImage)

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

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

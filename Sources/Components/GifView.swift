import ImageIO
import SwiftUI

public struct GifView: View {
    let name: String
    let size: CGSize

    @State private var frames: [(image: CGImage, duration: TimeInterval)] = []
    @State private var totalDuration: TimeInterval = 0

    public init(_ name: String, size: CGSize = CGSize(width: 200, height: 200)) {
        self.name = name
        self.size = size
    }

    public var body: some View {
        TimelineView(.animation) { context in
            if frames.isEmpty {
                Color.clear
                    .frame(width: size.width, height: size.height)
            } else {
                Image(decorative: currentFrame(at: context.date), scale: 1)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            }
        }
        .task { loadFrames() }
    }

    private func currentFrame(at date: Date) -> CGImage {
        let elapsed = date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: totalDuration)
        var accumulated: TimeInterval = 0
        for frame in frames {
            accumulated += frame.duration
            if elapsed < accumulated { return frame.image }
        }
        return frames.last!.image
    }

    private func loadFrames() {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "gif"),
            let data = try? Data(contentsOf: url),
            let source = CGImageSourceCreateWithData(data as CFData, nil)
        else { return }

        let count = CGImageSourceGetCount(source)
        var loaded: [(CGImage, TimeInterval)] = []
        var total: TimeInterval = 0

        for i in 0 ..< count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            let props = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any]
            let gifProps = props?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
            let duration = gifProps?[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval ?? 0.1
            loaded.append((cgImage, duration))
            total += duration
        }

        frames = loaded
        totalDuration = total
    }
}

// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [:]
    )
#endif

let package = Package(
    name: "Pitstop",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Navigator", from: "2.0.0"),
    ]
)

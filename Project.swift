import ProjectDescription

let project = Project(
    name: "Pitstop",
    settings:
    .settings(
        base: ["SWIFT_VERSION": "6.0"],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "./xcconfigs/Debug.xcconfig"
            ),
        ]
    ),
    targets: [
        .target(
            name: "Pitstop-APP",
            destinations: .iOS,
            product: .app,
            // [!code ++] // or .staticFramework, .staticLibrary...
            bundleId: "com.academy.pitstopD",
            deploymentTargets:
            .iOS(
                "17.0"
            ),
            infoPlist:
            .file(
                path: "Sources/Pitstop-APP-Info.plist"
            ),
            sources: ["Sources/**"],
            resources: [
                "Sources/Resources/**",
                "Sources/Assets.xcassets/**",
                "Sources/Preview Content/**"
            ],
            entitlements: "Pitstop-APP.entitlements",
            scripts: [
                .pre(
                    script: "Scripts/swiftformat.sh",
                    name: "SwiftFormat",
                    basedOnDependencyAnalysis: false
                ),
                .pre(
                    script: "Scripts/swiftlint.sh",
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                /** Dependencies go here **/
                /** .external(name: "Kingfisher") **/
                /** .target(name: "OtherProjectTarget") **/
            ],
            settings:
            .settings(
                configurations: [
                    .debug(
                        name: "Debug",
                        settings: ["SWIFT_VERSION": "6.0"],
                        xcconfig: "./xcconfigs/Debug.xcconfig"
                    ),
                ]
            )
        ),
        .target(
            name: "UnitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.academy.pitstopD",
            infoPlist: .default,
            sources: ["Tests/UnitTests/**"],
            dependencies: [
                .target(
                    name: "Pitstop-APP"
                )
            ]
        ),
    ]
)

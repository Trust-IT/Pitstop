import ProjectDescription

let project = Project(
    name: "ChassisUI",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "CLANG_ENABLE_MODULES": "YES"
        ]
    ),
    targets: [
        .target(
            name: "ChassisUI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.academy.pitstopD.ChassisUI",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [
                "Resources/Assets.xcassets/**"
            ],
            dependencies: [],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "NO"
            ])
        )
    ]
)

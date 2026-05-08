import ProjectDescription

let project = Project(
    name: "PitstopData",
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "CLANG_ENABLE_MODULES": "YES"
        ]
    ),
    targets: [
        .target(
            name: "PitstopData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.academy.pitstopD.PitstopData",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        )
    ]
)

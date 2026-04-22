import ProjectDescription

let project = Project(
    name: "Pitstop",
    settings:
    .settings(
        base: [
            "SWIFT_VERSION": "6.0",
            "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": "YES",
            "CLANG_ANALYZER_NONNULL": "YES",
            "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION": "YES_AGGRESSIVE",
            "CLANG_CXX_LANGUAGE_STANDARD": "gnu++17",
            "CLANG_ENABLE_MODULES": "YES",
            "CLANG_ENABLE_OBJC_ARC": "YES",
            "CLANG_ENABLE_OBJC_WEAK": "YES",
            "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING": "YES",
            "CLANG_WARN_BOOL_CONVERSION": "YES",
            "CLANG_WARN_COMMA": "YES",
            "CLANG_WARN_CONSTANT_CONVERSION": "YES",
            "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS": "YES",
            "CLANG_WARN_DIRECT_OBJC_ISA_USAGE": "YES_ERROR",
            "CLANG_WARN_DOCUMENTATION_COMMENTS": "YES",
            "CLANG_WARN_EMPTY_BODY": "YES",
            "CLANG_WARN_ENUM_CONVERSION": "YES",
            "CLANG_WARN_INFINITE_RECURSION": "YES",
            "CLANG_WARN_INT_CONVERSION": "YES",
            "CLANG_WARN_NON_LITERAL_NULL_CONVERSION": "YES",
            "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF": "YES",
            "CLANG_WARN_OBJC_LITERAL_CONVERSION": "YES",
            "CLANG_WARN_OBJC_ROOT_CLASS": "YES_ERROR",
            "CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER": "YES",
            "CLANG_WARN_RANGE_LOOP_ANALYSIS": "YES",
            "CLANG_WARN_STRICT_PROTOTYPES": "YES",
            "CLANG_WARN_SUSPICIOUS_MOVE": "YES",
            "CLANG_WARN_UNGUARDED_AVAILABILITY": "YES_AGGRESSIVE",
            "CLANG_WARN_UNREACHABLE_CODE": "YES",
            "CLANG_WARN__DUPLICATE_METHOD_MATCH": "YES",
            "COPY_PHASE_STRIP": "NO",
            "ENABLE_STRICT_OBJC_MSGSEND": "YES",
            "GCC_C_LANGUAGE_STANDARD": "gnu11",
            "GCC_NO_COMMON_BLOCKS": "YES",
            "GCC_WARN_64_TO_32_BIT_CONVERSION": "YES",
            "GCC_WARN_ABOUT_RETURN_TYPE": "YES_ERROR",
            "GCC_WARN_UNDECLARED_SELECTOR": "YES",
            "GCC_WARN_UNINITIALIZED_AUTOS": "YES_AGGRESSIVE",
            "GCC_WARN_UNUSED_FUNCTION": "YES",
            "GCC_WARN_UNUSED_VARIABLE": "YES",
            "MTL_FAST_MATH": "YES",
        ],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: "./xcconfigs/Debug.xcconfig"
            ),
            .release(
                name: "Release",
                xcconfig: "./xcconfigs/Release.xcconfig"
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
                "26.0"
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
                    .release(
                        name: "Release",
                        settings: ["SWIFT_VERSION": "6.0"],
                        xcconfig: "./xcconfigs/Release.xcconfig"
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

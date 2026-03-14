// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CaptureOneReconstructed",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "CaptureOneApp", targets: ["CaptureOneApp"]),
        .library(name: "AppCoreShared", targets: ["AppCoreShared"]),
        .library(name: "ImageCore", targets: ["ImageCore"]),
        .library(name: "DataCore", targets: ["DataCore"]),
        .library(name: "Cloud", targets: ["Cloud"]),
        .library(name: "CaptureOneUI", targets: ["CaptureOneUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.54.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.52.11")
    ],
    targets: [
        .executableTarget(
            name: "CaptureOneApp",
            dependencies: ["AppCoreShared", "DataCore", "ImageCore", "CaptureOneUI", "Cloud"],
            path: "Sources/CaptureOneApp",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "Cloud",
            dependencies: [],
            path: "Sources/Cloud",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "DataCore",
            dependencies: [],
            path: "Sources/DataCore",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "AppCoreShared",
            dependencies: ["DataCore", "ImageCore"],
            path: "Sources/AppCoreShared",
            resources: [.copy("Resources")],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "ImageCore",
            dependencies: [],
            path: "Sources/ImageCore",
            resources: [.copy("Resources")],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "CaptureOneUI",
            dependencies: ["AppCoreShared", "ImageCore", "DataCore"],
            path: "Sources/CaptureOneUI",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "AppCoreSharedTests",
            dependencies: ["AppCoreShared"],
            path: "Tests/AppCoreSharedTests"
        ),
        .testTarget(
            name: "DataCoreTests",
            dependencies: ["DataCore"],
            path: "Tests/DataCoreTests"
        ),
        .testTarget(
            name: "ImageCoreTests",
            dependencies: ["ImageCore"],
            path: "Tests/ImageCoreTests"
        ),
        .testTarget(
            name: "CaptureOneUITests",
            dependencies: ["CaptureOneUI", "AppCoreShared", "DataCore"],
            path: "Tests/CaptureOneUITests"
        )
    ]
)

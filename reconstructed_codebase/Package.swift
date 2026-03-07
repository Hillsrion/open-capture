// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CaptureOneReconstructed",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "AppCoreShared", targets: ["AppCoreShared"]),
        .library(name: "ImageCore", targets: ["ImageCore"]),
        .library(name: "DataCore", targets: ["DataCore"]),
        .library(name: "CaptureOneUI", targets: ["CaptureOneUI"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DataCore",
            dependencies: [],
            path: "Sources/DataCore"
        ),
        .target(
            name: "AppCoreShared",
            dependencies: ["DataCore"],
            path: "Sources/AppCoreShared"
        ),
        .target(
            name: "ImageCore",
            dependencies: ["AppCoreShared"],
            path: "Sources/ImageCore"
        ),
        .target(
            name: "CaptureOneUI",
            dependencies: ["AppCoreShared", "ImageCore", "DataCore"],
            path: "Sources/CaptureOneUI"
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
        )
    ]
)

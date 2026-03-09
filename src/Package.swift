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
        .library(name: "CaptureOneUI", targets: ["CaptureOneUI"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CaptureOneApp",
            dependencies: ["AppCoreShared", "DataCore", "ImageCore", "CaptureOneUI"],
            path: "Sources/CaptureOneApp"
        ),
        .target(
            name: "DataCore",
            dependencies: [],
            path: "Sources/DataCore"
        ),
        .target(
            name: "AppCoreShared",
            dependencies: ["DataCore", "ImageCore"],
            path: "Sources/AppCoreShared",
            resources: [.copy("../../Contents/Resources")]
        ),
        .target(
            name: "ImageCore",
            dependencies: [],
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
        ),
        .testTarget(
            name: "CaptureOneUITests",
            dependencies: ["CaptureOneUI", "AppCoreShared", "DataCore"],
            path: "Tests/CaptureOneUITests"
        )
    ]
)

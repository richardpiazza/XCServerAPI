// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "XCServerAPI",
    products: [
        .library(name: "XCServerAPI", targets: ["XCServerAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/CodeQuickKit.git", from: "6.4.1"),
        .package(url: "https://github.com/richardpiazza/BZipCompression.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "XCServerAPI", dependencies: ["CodeQuickKit", "BZipCompression"], path: "Sources"),
        .testTarget(name: "XCServerAPITests", dependencies: ["XCServerAPI"], path:"Tests")
    ]
)

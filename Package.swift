// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "XCServerAPI",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: [
        .library(name: "XCServerAPI", targets: ["XCServerAPI"])
    ],
    dependencies: [
        .package(url: "https://github.com/richardpiazza/CodeQuickKit.git", from: "6.6.0"),
//        .package(url: "https://github.com/richardpiazza/BZipCompression.git", from: "1.1.0")
        .package(url: "https://github.com/tsolomko/BitByteData.git", from: "1.4.0"),
    ],
    targets: [
        .target(name: "SWCompression", dependencies: ["BitByteData"]),
        .target(name: "XCServerAPI", dependencies: ["CodeQuickKit", "SWCompression"]),
        .testTarget(name: "XCServerAPITests", dependencies: ["XCServerAPI"], path:"Tests")
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)

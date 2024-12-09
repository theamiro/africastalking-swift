// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AfricasTalkingSwift",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AfricasTalkingSwift",
            targets: ["AfricasTalkingSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.2")
    ],
    targets: [
        .target(name: "AfricasTalkingSwift", dependencies: [
            .product(name: "Logging", package: "swift-log")
        ]),
        .testTarget(
            name: "AfricasTalkingSwiftTests",
            dependencies: ["AfricasTalkingSwift"]
        ),
    ],
    swiftLanguageVersions: [.version("6"), .v5]
)

// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyOpus",
    platforms: [
        .macOS(.v15_10), .iOS(.v12_4)
    ],
    products: [
        .library(
            name: "SwiftyOpus",
            targets: ["SwiftyOpus"]),
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "SwiftyOpus",
            url: "https://github.com/TheJKM/opus-swift/releases/download/1.3.1/SwiftyOpus.xcframework.zip",
            checksum: "385dafba097331afef86bf33da4d697d1a30ccc7e1e076c70f8c2a3fcb6f4638"
            )
    ]
)

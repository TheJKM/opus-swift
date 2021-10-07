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
            name: "YbridOpus", 
            url: "https://github.com/TheJKM/opus-swift/releases/download/1.3.1/SwiftyOpus.xcframework.zip",
            checksum: "66fc6c6798f19db7cc6ddf5ccef8760a7bf9e068d72f16165da2326e8ae80829"
            )
    ]
)

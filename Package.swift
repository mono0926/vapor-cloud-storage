// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "VaporCloudStorage",
    products: [
        .library(
            name: "VaporCloudStorage",
            targets: ["VaporCloudStorage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", 
                 from: "2.0.0")
    ],
    targets: [
        .target(
            name: "VaporCloudStorage",
            dependencies: ["Vapor"]),
        .testTarget(
            name: "VaporCloudStorageTests",
            dependencies: ["VaporCloudStorage"]),
    ]
)

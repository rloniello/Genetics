// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Genetics",
    products: [
        .library(
            name: "Genetics",
            targets: ["Genetics"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Genetics",
            dependencies: []),
        .testTarget(
            name: "GeneticsTests",
            dependencies: ["Genetics"]),
    ]
)

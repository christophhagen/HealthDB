// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "HealthDB",
    platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9)],
    products: [
        .library(
            name: "HealthDB",
            targets: ["HealthDB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.14.1"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.25.2"),
        .package(url: "https://github.com/christophhagen/HealthKitExtensions", branch: "main"), //from: "0.3.3"),
    ],
    targets: [
        .target(
            name: "HealthDB",
        dependencies: [
            .product(name: "SQLite", package: "sqlite.swift"),
            .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            .product(name: "HealthKitExtensions", package: "HealthKitExtensions")
        ]),
        .testTarget(
            name: "HKDatabaseTests",
            dependencies: ["HealthDB"]),
    ]
)

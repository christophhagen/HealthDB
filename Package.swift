// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "iOSHealthDBInterface",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "HKDatabase",
            targets: ["HKDatabase"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.14.1"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.25.2"),
        .package(url: "https://github.com/christophhagen/HealthKitExtensions", from: "0.1.1"),
    ],
    targets: [
        .target(
            name: "HKDatabase",
        dependencies: [
            .product(name: "SQLite", package: "sqlite.swift"),
            .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            .product(name: "HealthKitExtensions", package: "HealthKitExtensions")
        ]),
        .testTarget(
            name: "HKDatabaseTests",
            dependencies: ["HKDatabase"]),
    ]
)

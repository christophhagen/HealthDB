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
        .package(url: "https://github.com/christophhagen/HealthKitExtensions", from: "0.4.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "HealthDB",
        dependencies: [
            .product(name: "SQLite", package: "sqlite.swift"),
            .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            .product(name: "HealthKitExtensions", package: "HealthKitExtensions"),
        ],
        exclude: [
            "HealthDB/Model/ECG/ECGVoltageData.proto",
            "HealthDB/Model/Workouts/EventMetadata.proto",
        ]),
        .testTarget(
            name: "HKDatabaseTests",
            dependencies: ["HealthDB"]),
    ]
)

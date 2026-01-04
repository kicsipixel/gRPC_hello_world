// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hello_word",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift-2.git", from: "2.2.1"),
        .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "2.1.2"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.33.3"),
        .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "2.4.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "hello_world",
            dependencies: [
                .product(name: "GRPCCore", package: "grpc-swift-2"),
                .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
        )
    ]
)

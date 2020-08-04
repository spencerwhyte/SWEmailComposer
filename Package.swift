// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SWEmailComposer",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SWEmailComposer",
            targets: ["SWEmailComposer"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SWEmailComposer",
            path: "SWEmailComposer")
    ]
)

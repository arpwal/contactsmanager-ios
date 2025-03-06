// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    version: "0.1.2",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ContactsManager",
            targets: ["ContactsManager"]),
        .library(
            name: "ContactsManagerBinary",
            targets: ["ContactsManagerBinary"])
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        // Swift source code target that wraps the binary
        .target(
            name: "ContactsManager",
            dependencies: [],
        ),
        // Binary framework target
        .binaryTarget(
            name: "ContactsManagerBinary",
            path: "ContactsManager.xcframework"
        )
    ]
)
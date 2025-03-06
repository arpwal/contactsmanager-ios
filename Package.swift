// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    version: "0.3.0",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ContactsManager",
            targets: ["ContactsManager"])
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        // Binary framework target
        .binaryTarget(
            name: "ContactsManagerBinary",
            path: "ContactsManager.xcframework"
        ),
        // Swift source code target that wraps the binary
        .target(
            name: "ContactsManager",
            dependencies: ["ContactsManagerBinary"],
            path: "ContactsManager.xcframework"
        )
    ]
)
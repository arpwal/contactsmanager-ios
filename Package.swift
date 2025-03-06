// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    version: "0.1.1",
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
        // Binary framework target
        .binaryTarget(
            name: "ContactsManagerBinary",
            path: "ContactsManager.xcframework"
        ),
        // Swift source code target
        .target(
            name: "ContactsManager",
            dependencies: ["ContactsManagerBinary"],
            path: "Sources/ContactsManager"
        )
    ]
)
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
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
        .binaryTarget(
            name: "ContactsManagerBinary",
            path: "ContactsManager.xcframework"
        ),
        .target(
            name: "ContactsManager",
            dependencies: ["ContactsManagerBinary"],
            path: "Sources/ContactsManager")
    ]
)
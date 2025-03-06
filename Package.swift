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
            targets: ["ContactsManager"])
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        .binaryTarget(
            name: "ContactsManager",
            path: "ContactsManager.xcframework"
        )
    ]
)
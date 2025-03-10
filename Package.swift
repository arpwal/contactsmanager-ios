// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    products: [
        .library(
            name: "ContactsManagerBinary",
            targets: ["ContactsManagerBinary"])
    ],
    dependencies: [
        // No dependencies
    ],
    targets: [
        .binaryTarget(
            name: "ContactsManagerBinary",
            path: "ContactsManagerBinary.xcframework"
        )
    ]
)

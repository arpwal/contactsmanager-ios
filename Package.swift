// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ContactsManager",
            targets: ["ContactsManager"])
    ],
    dependencies: [
        // No dependencies
    ],
    targets: [
        .binaryTarget(
            name: "ContactsManager",
            path: "contactsmanagerpackage.xcframework"
        )
    ]
)
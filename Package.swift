// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManagerPackage",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ContactsManagerPackage",
            targets: ["ContactsManagerPackage"])
    ],
    dependencies: [
        // No dependencies
    ],
    targets: [
        .binaryTarget(
            name: "ContactsManagerPackage",
            path: "ContactsManagerPackage.xcframework"
        )
    ]
)
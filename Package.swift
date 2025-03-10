// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManagerPackage",
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

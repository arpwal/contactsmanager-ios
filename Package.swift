// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ContactsManager",
            targets: ["ContactsManager"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "20.0.1")
    ],
    targets: [
        .binaryTarget(
            name: "ContactsManager",
            path: "ContactsManager.xcframework"
        )
    ]
)
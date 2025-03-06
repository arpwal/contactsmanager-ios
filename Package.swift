// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactsManager",
    version: "0.0.1",
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
            url: "https://github.com/arpwal/contactsmanager-ios/releases/download/0.0.1/ContactsManager.xcframework.zip",
            checksum: "5dab672b5a1f8ea55a5759dbb72e7f435cb59c4b9e705b35df71ce75aa336e2e"
        )
    ]
)
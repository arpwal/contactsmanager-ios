// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ContactManagerKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ContactManagerKit",
            targets: ["ContactManagerKit"]),
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        .target(
            name: "ContactManagerKit",
            dependencies: [],
            path: "../ios/Sources/ContactManagerKit"),
        .testTarget(
            name: "ContactManagerKitTests",
            dependencies: ["ContactManagerKit"],
            path: "../ios/Tests/ContactManagerKitTests"),
    ]
) 
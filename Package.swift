// swift-tools-version:5.9
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
      path: "ContactsManager.xcframework"
    )
  ]
)

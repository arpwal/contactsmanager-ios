# Contacts Manager for Businesses - iOS Package

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![Version](https://img.shields.io/badge/version-1.2.0-green.svg)](https://github.com/arpwal/contactsmanager-ios/releases)

A powerful contacts management framework for iOS business applications.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/arpwal/contactsmanager-ios.git", .exact("1.2.0"))
]
```

Or in Xcode:
1. File > Add Packages
2. Enter Package URL: `https://github.com/arpwal/contactsmanager-ios.git`
3. Select "Exact Version" and enter "0.0.1"

## Features

- Comprehensive contact management
- Business-focused contact organization
- iOS 17+ support
- Swift 5.5+ compatibility

## Requirements

- iOS 17.0+
- Swift 5.5+
- Xcode 13.0+

## Usage

Import the framework in your Swift file:

```swift
import ContactsManager
```

## Documentation

The ContactsManager SDK provides comprehensive documentation for all major features:

### [Authorization & Access](docs/Authorization.md)
Learn how to handle contacts access permissions, initialize the SDK, and manage service state.

### [Contact Search & Access](docs/ContactSearch.md)
Explore methods for fetching and searching contacts based on different criteria.

### [Contact Picker UI](docs/ContactPicker.md)
Learn how to present and use the SwiftUI-based contact picker in your UIKit applications.

## Demo App

Check out our demo app to see the SDK in action! The demo app showcases the basic functionality and integration patterns of the Contacts Manager SDK.

[Demo App Repository](https://github.com/arpwal/contactsmanager-demo)

The demo app includes:
- Complete SDK integration example
- Basic contact management features
- Step-by-step setup guide
- Real-world usage patterns

## License

This project is licensed under the terms specified in the LICENSE file.

## Latest Release

Current Version: 1.2.0
Release Date: 2025-03-11
[Release Notes](https://github.com/arpwal/contactsmanager-ios/releases)


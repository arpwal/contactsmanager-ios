# Contact Picker UI

The ContactsManager provides a SwiftUI-based contact picker that can be presented from any UIKit view controller.

## Requirements
- iOS 13.0+
- SwiftUI
- Contacts access permission
- ContactsManager must be initialized

## Basic Usage
```swift
import UIKit
import ContactsManager

class YourViewController: UIViewController {
    func showContactPicker() {
        let options = ContactSelectionOptions() // Configure options as needed
        ContactsManagerUI.getInstance().searchContacts(
            from: self,
            options: options
        ) { result in
            switch result {
            case .success(let contacts):
                // Handle selected contacts
                print("Selected \(contacts.count) contacts")
            case .failure(let error):
                // Handle error
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
```

## Error Handling
The contact picker may return the following errors:
- `ContactsServiceError.notInitialized`: When ContactsManager hasn't been initialized
- Other errors from the underlying contacts service

## Presentation
The contact picker is presented as a modal sheet and cannot be dismissed by swipe gestures. It requires:
- A valid UIViewController to present from
- ContactsManager to be properly initialized
- Valid contact selection options

## SwiftUI Integration
The contact picker is built using SwiftUI but is designed to work seamlessly with UIKit applications. It's presented using a `UIHostingController` to bridge between UIKit and SwiftUI. 
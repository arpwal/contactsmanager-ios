# Authorization & Access

The ContactsManager requires proper authorization to access the device's contacts. Here's how to handle authorization:

## Initialization
```swift
// Initialize with API key and optional configuration
try await ContactsService.shared.initialize(
    withAPIKey: "your-api-key",
    options: .default
)
```

## Requesting Access
```swift
// Request contacts access
let accessGranted = await ContactsService.shared.requestContactsAccess()
if accessGranted {
    // Access granted, contacts will be synced automatically
} else {
    // Handle access denied
}
```

## Checking Authorization Status
```swift
// Get current authorization status
let status = ContactsService.shared.contactsAccessStatus
switch status {
case .authorized:
    // Full access granted
case .denied:
    // Access denied
case .restricted:
    // Access restricted
case .notDetermined:
    // Not requested yet
case .limitedAuthorized:
    // Limited access (iOS 15+)
}
```

## Settings Alert
```swift
// Check if contacts access is required
if ContactsService.shared.authorization.shouldShowSettingsAlert() {
    // Show settings alert view
    ContactsService.shared.settingsAlert
}
```

## Event Handling
```swift
// Listen for contacts access changes
.onContactsManagerEvent(.contactsAccessChanged, identifier: "YourIdentifier") {
    // Handle access changes
    // Contacts will be automatically synced when access is granted
}
```

## Error Handling
The service may throw the following errors during initialization:
- `ContactsServiceError.invalidAPIKey`: When the provided API key is invalid
- `ContactsServiceError.contactsAccessDenied`: When contacts access permission is denied
- `ContactsServiceError.initializationFailed`: When initialization fails for other reasons
- `ContactsServiceError.notInitialized`: When trying to use the service before initialization

## Service State
```swift
// Check if the service is initialized
let isReady = ContactsService.shared.isInitialized

// Get current state as string
let state = ContactsService.shared.currentState // Returns: "Not initialized", "Initializing", "Ready", or "Failed: [error]"
```

## Reset Service
```swift
// Reset the service to uninitialized state
try await ContactsService.shared.reset()
``` 
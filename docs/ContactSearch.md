# Accessing & Searching Contacts

The ContactsManager provides powerful methods to access and search contacts based on different criteria. All contacts are automatically synced when access is granted and kept up to date.

## Fetching Contacts by Field Type
```swift
// Fetch contacts with phone numbers
let contactsWithPhone = try await ContactsService.shared.fetchContacts(fieldType: .phone)

// Fetch contacts with email addresses
let contactsWithEmail = try await ContactsService.shared.fetchContacts(fieldType: .email)

// Fetch all contacts
let allContacts = try await ContactsService.shared.fetchContacts(fieldType: .any)

// Fetch contacts with notes (requires special entitlement)
let contactsWithNotes = try await ContactsService.shared.fetchContacts(fieldType: .notes)
```

## Fetching Individual Contacts
```swift
// Fetch a specific contact by ID
if let contact = try await ContactsService.shared.fetchContact(withId: "contact-id") {
    // Use the contact
}
```

## Contact Field Types
The following field types are supported for filtering contacts:
- `.phone`: Contacts with phone numbers
- `.email`: Contacts with email addresses
- `.notes`: Contacts with notes (requires special entitlement)
- `.any`: All contacts regardless of field type

## Automatic Syncing
The ContactsManager automatically:
- Syncs contacts when access is initially granted
- Updates when contacts change on the device
- Maintains a local cache for fast access
- Handles background updates efficiently

## Notes Access
To access contact notes, you need special entitlement from Apple:
1. Apply for the entitlement at: https://developer.apple.com/contact/request/contact-note-field
2. Add the entitlement to your app's entitlements file
3. Include `.notes` in your `restrictedKeysToFetch` options during initialization 
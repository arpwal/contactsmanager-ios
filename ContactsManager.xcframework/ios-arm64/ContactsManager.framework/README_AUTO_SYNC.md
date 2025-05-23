# Auto Sync Functionality in ContactsManager

## Overview

The ContactsManager SDK now supports configurable automatic contact synchronization. This feature allows you to control when contacts are automatically synced from the device to the cloud.

## Configuration Options

### During Initialization

You can configure auto sync behavior during SDK initialization using `ContactsManagerOptions`:

```swift
import ContactsManager

// Enable auto sync (default behavior)
let optionsWithAutoSync = ContactsManagerOptions(
    restrictedKeysToFetch: [],
    verboseLogging: false,
    autoSyncEnabled: true  // Contacts will sync automatically
)

try await ContactsService.shared.initialize(
    withAPIKey: "your-api-key",
    token: "your-token",
    userInfo: userInfo,
    options: optionsWithAutoSync
)

// Disable auto sync
let optionsWithoutAutoSync = ContactsManagerOptions(
    restrictedKeysToFetch: [],
    verboseLogging: false,
    autoSyncEnabled: false  // Contacts will NOT sync automatically
)

try await ContactsService.shared.initialize(
    withAPIKey: "your-api-key",
    token: "your-token",
    userInfo: userInfo,
    options: optionsWithoutAutoSync
)
```

### After Initialization

You can also enable or disable auto sync at any time after initialization:

```swift
// Enable auto sync after initialization
ContactsService.shared.autoSyncEnabled = true

// Disable auto sync after initialization
ContactsService.shared.autoSyncEnabled = false

// Check current auto sync status
let isAutoSyncEnabled = ContactsService.shared.autoSyncEnabled
print("Auto sync is \(isAutoSyncEnabled ? "enabled" : "disabled")")
```

## Auto Sync Behavior

### When Auto Sync is Enabled (default)

Contacts will automatically sync in the following scenarios:

1. **App becomes active**: When your app comes to the foreground
2. **Contact store changes**: When the device's contact store is modified
3. **Contact access granted**: When the user grants contacts access after previously denying it
4. **Initial sync**: During SDK initialization (if contacts access is available)

### When Auto Sync is Disabled

- Contacts will **NOT** sync automatically in any of the above scenarios
- You must manually trigger sync by calling `syncContacts()` when needed
- Background task scheduling still occurs (for when you manually sync)
- Initial sync during initialization is skipped

## Manual Sync

Regardless of the auto sync setting, you can always manually trigger a sync:

```swift
do {
    let syncedCount = try await ContactsService.shared.syncContacts()
    print("Successfully synced \(syncedCount) contacts")
} catch {
    print("Sync failed: \(error.localizedDescription)")
}
```

## Use Cases

### When to Enable Auto Sync

- **Real-time contact apps**: Apps that need the latest contact information immediately
- **Social networking apps**: Apps that rely on up-to-date contact data for features
- **Communication apps**: Apps where contact changes should be reflected quickly

### When to Disable Auto Sync

- **Battery-conscious apps**: Apps that want to minimize background activity
- **Controlled sync timing**: Apps that want to sync only at specific times (e.g., app launch, user action)
- **Bandwidth-limited scenarios**: Apps used in environments with limited network connectivity
- **User preference**: When users prefer manual control over data synchronization

## Example Implementation

```swift
import SwiftUI
import ContactsManager

@main
struct MyApp: App {
    @State private var autoSyncEnabled = true

    init() {
        // Configure auto sync based on user preference or app requirements
        Task {
            do {
                let options = ContactsManagerOptions(
                    autoSyncEnabled: autoSyncEnabled
                )

                try await ContactsService.shared.initialize(
                    withAPIKey: "your-api-key",
                    userInfo: UserInfo(userId: "user-123", email: "user@example.com"),
                    options: options
                )
            } catch {
                print("Failed to initialize ContactsManager: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var autoSyncEnabled = ContactsService.shared.autoSyncEnabled
    @State private var syncStatus = "Ready"

    var body: some View {
        VStack(spacing: 20) {
            Text("ContactsManager Auto Sync Demo")
                .font(.title)

            Toggle("Auto Sync Enabled", isOn: $autoSyncEnabled)
                .onChange(of: autoSyncEnabled) { newValue in
                    ContactsService.shared.autoSyncEnabled = newValue
                }

            Text("Status: \(syncStatus)")
                .foregroundColor(.secondary)

            Button("Manual Sync") {
                Task {
                    do {
                        syncStatus = "Syncing..."
                        let count = try await ContactsService.shared.syncContacts()
                        syncStatus = "Synced \(count) contacts"
                    } catch {
                        syncStatus = "Sync failed: \(error.localizedDescription)"
                    }
                }
            }
            .disabled(syncStatus == "Syncing...")

            Spacer()
        }
        .padding()
        .onAppear {
            // Set up sync completion callback
            ContactsService.shared.onContactsSynced = { metrics in
                DispatchQueue.main.async {
                    syncStatus = """
                    Auto sync completed:
                    New: \(metrics.newContacts)
                    Updated: \(metrics.updatedContacts)
                    Total: \(metrics.totalProcessed)
                    """
                }
            }
        }
    }
}
```

## Migration Guide

If you're upgrading from a previous version of ContactsManager:

### No Changes Required

The default behavior remains the same - auto sync is enabled by default. Your existing code will continue to work without any modifications.

### To Disable Auto Sync

If you want to disable auto sync for your existing app:

```swift
// Option 1: During initialization
let options = ContactsManagerOptions(autoSyncEnabled: false)
try await ContactsService.shared.initialize(
    withAPIKey: apiKey,
    userInfo: userInfo,
    options: options
)

// Option 2: After initialization
ContactsService.shared.autoSyncEnabled = false
```

## Best Practices

1. **Consider user preferences**: Allow users to control auto sync behavior in your app settings
2. **Monitor battery usage**: If auto sync is causing battery drain, consider disabling it or reducing sync frequency
3. **Handle sync errors gracefully**: Always implement proper error handling for both auto and manual sync
4. **Provide feedback**: Use the `onContactsSynced` callback to inform users about sync status
5. **Test both modes**: Ensure your app works correctly with both auto sync enabled and disabled

## Logging

When verbose logging is enabled, you'll see log messages indicating auto sync status:

```
[ContactsManager] Auto sync enabled from initialization options
[ContactsManager] Auto sync disabled
[ContactsManager] Auto sync enabled
[ContactsManager] Auto sync is disabled, skipping initial sync. Call syncContacts() manually to sync contacts.
```

This helps with debugging and understanding the current auto sync behavior in your app.

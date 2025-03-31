# Background Task Configuration

## Overview

The ContactsManager SDK uses the BackgroundTasks framework to synchronize contacts in the background. To use this feature, you need to properly configure your app with the required capabilities and entitlements.

## Configuration Steps

### 1. Add Background Modes Capability

1. In Xcode, select your app target
2. Go to the "Signing & Capabilities" tab
3. Click the "+" button to add a capability
4. Select "Background Modes"
5. Check the "Background Processing" option

### 2. Configure Info.plist

Add the following entries to your app's Info.plist file:

```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.contactsmanager.contact-sync</string>
</array>
```

### 3. Register for Background Tasks in AppDelegate

In your AppDelegate's `application(_:didFinishLaunchingWithOptions:)` method, add the following code:

```swift
import BackgroundTasks

// In application(_:didFinishLaunchingWithOptions:)
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Register background tasks
    BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.contactsmanager.contact-sync",
        using: nil
    ) { task in
        // For simplicity, delegate to ContactsManager to handle the task
        if let bgTask = task as? BGProcessingTask {
            let contactsManager = ContactsManager.shared
            Task {
                do {
                    let syncCount = try await contactsManager.syncContacts()
                    bgTask.setTaskCompleted(success: true)
                } catch {
                    bgTask.setTaskCompleted(success: false)
                }
            }
            
            // Set expiration handler
            bgTask.expirationHandler = {
                // Cancel any work when task expires
            }
        }
    }
    
    // Rest of your app initialization
    return true
}
```

Alternatively, you can let the ContactsManager register the background task for you:

```swift
// In your app initialization code
let contactManager = ContactsManager.shared
contactManager.registerBackgroundTasks() // Explicitly register background tasks
```

### 4. Schedule Background Tasks

The ContactsManager SDK automatically schedules background synchronization after each successful sync. If you want to manually trigger background sync scheduling, you can use:

```swift
ContactsManager.shared.scheduleBackgroundSync()
```

## Troubleshooting

If you encounter errors related to background tasks, check the following:

1. Verify that your app has the "Background Processing" capability enabled
2. Make sure the "BGTaskSchedulerPermittedIdentifiers" is properly set in Info.plist
3. Check that you're correctly registering the background task identifier, either in your AppDelegate or by calling `registerBackgroundTasks()`

Common error codes:

- `BGTaskSchedulerErrorDomain error 1`: Invalid task identifier
- `BGTaskSchedulerErrorDomain error 2`: Task already running 
- `BGTaskSchedulerErrorDomain error 3`: Insufficient permissions (missing entitlements)
- `BGTaskSchedulerErrorDomain error 4`: Too many tasks pending

## Best Practices

1. Always register background tasks as early as possible in app initialization
2. Handle task expiration by implementing the expiration handler
3. Always set task completion status with `setTaskCompleted(success:)` 
4. Keep background tasks focused on essential work to avoid being terminated by the system

## References

- [Apple Documentation: Performing Background Tasks](https://developer.apple.com/documentation/backgroundtasks/performing_background_tasks)
- [Apple WWDC 2019: Advances in Background Tasks](https://developer.apple.com/videos/play/wwdc2019/707/) 
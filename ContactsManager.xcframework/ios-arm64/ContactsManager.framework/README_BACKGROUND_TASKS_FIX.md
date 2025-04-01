# Background Tasks in ContactsManager

## Overview
ContactsManager supports background tasks for contact synchronization, but this is entirely optional. Your app will function correctly with or without background sync enabled.

## Background Sync is Optional

Background sync allows ContactsManager to periodically update contacts even when your app is not in the foreground. However:

- Background sync is **NOT required** for normal app operation
- Your app will function perfectly without it
- Contact synchronization still happens automatically when the app is active
- Background sync is completely opt-in
- The SDK respects user and system settings about background execution

## Enabling Background Sync (Optional)

If you want to enable background sync, simply call this method during app initialization:

```swift
import SwiftUI
import ContactsManager

@main
struct YourApp: App {
    init() {
        // Optional: Enable background contact synchronization
        ContactsService.shared.enableBackgroundSync()
        
        // Rest of your initialization code...
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

This method will:
- Register the background task handler with the system
- Respect user settings about background execution
- Fail gracefully if background tasks can't be registered

## When Background Sync Won't Work

Even if you enable background sync in your code, it might not work if:

1. **App Settings**: The user has disabled Background App Refresh for your app in Settings
2. **Missing Entitlements**: Your app doesn't have the necessary Background Processing entitlement
3. **System Restrictions**: The device is in Low Power Mode or has other system restrictions
4. **Info.plist Configuration**: Your app's Info.plist is missing the required configuration

The SDK will handle all these cases gracefully without crashing or affecting normal operation.

## Required App Configuration (Only if Using Background Sync)

If you choose to enable background sync, you'll need these configurations:

1. **Info.plist Configuration**
   
   ```xml
   <key>BGTaskSchedulerPermittedIdentifiers</key>
   <array>
       <string>com.contactsmanager.contact-sync</string>
   </array>
   ```

2. **Enable Background Modes**

   1. In Xcode, select your app target
   2. Go to the "Signing & Capabilities" tab
   3. Add the "Background Modes" capability
   4. Check the "Background Processing" option

## If You Don't Want Background Sync

If you don't want background sync:

1. Simply don't call `ContactsService.shared.enableBackgroundSync()` during app initialization
2. The SDK won't attempt to register or schedule any background tasks
3. All foreground synchronization will continue to work normally
4. No warnings or errors will be logged about missing background tasks
5. Users can still disable Background App Refresh for your app in Settings if they wish

## Technical Details

- ContactsManager is designed to work perfectly with or without background tasks
- Background task registration is completely separate from normal contact synchronization
- Background tasks are only registered when explicitly enabled
- The SDK respects all system and user settings about background execution
- All error conditions are handled gracefully with appropriate logging 
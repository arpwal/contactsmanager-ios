# Reactions System Integration - Swift SDK

## Overview

The ContactManager Swift SDK now includes a comprehensive reactions system that allows users to react to events with various emotion types. This system provides both predefined reaction types and support for custom reactions.

## 🎯 Key Features

- **Flexible Reaction Types**: Support for both predefined (like, love, super_like, support, etc.) and custom reaction types
- **Strongly Typed Models**: Clear, documented structures instead of generic dictionaries
- **Comprehensive API**: Full CRUD operations for reactions with batch support
- **Rich Metadata**: Optional metadata support for enhanced reactions
- **Real-time Integration**: Seamless integration with the existing social API
- **SwiftUI Ready**: Includes Canvas previews for quick UI iterations

## 📁 File Structure

### New Files Added

1. **`ReactionModels.swift`** - Complete reaction data models and types
2. **`SocialService+Reactions.swift`** - Reaction-specific service methods (extension)
3. **`REACTIONS_INTEGRATION.md`** - This documentation file

### Modified Files

1. **`APIConfig.swift`** - Added reaction endpoints
2. **`SocialEventModels.swift`** - Added reaction fields to SocialEvent
3. **`SocialService.swift`** - Updated documentation to reference reactions

## 🏗️ Architecture

### Reaction Types

```swift
public enum ReactionType: Codable, Equatable, CaseIterable {
  // Predefined types
  case like, love, superLike, support, laugh, wow, sad, angry

  // Custom types
  case custom(String)
}
```

**Predefined Types Available:**

- `.like` → "👍 Like"
- `.love` → "❤️ Love"
- `.superLike` → "🔥 Super Like"
- `.support` → "💪 Support"
- `.laugh` → "😂 Laugh"
- `.wow` → "😮 Wow"
- `.sad` → "😢 Sad"
- `.angry` → "😠 Angry"

**Custom Types:**

```swift
let fireReaction = ReactionType.custom("fire")
let celebrateReaction = ReactionType.custom("celebrate")
```

### Key Models

#### `EventReaction`

Represents a single user's reaction to an event with complete user information.

#### `EventReactionsSummary`

Aggregated summary with counts by reaction type and recent reactors.

#### `EventWithReactions`

Event data enriched with complete reaction information.

#### `ReactionMetadata`

Optional additional data that can be attached to reactions (comments, intensity, custom properties).

## 🚀 API Usage

### Basic Reactions

```swift
let cm = ContactsService.shared

// React to an event
let response = try await cm.social.react(
  eventId: "event-123",
  reactionType: .like
)

// React with custom type
let response = try await cm.social.react(
  eventId: "event-123",
  reactionType: "fire"  // String convenience method
)

// React with metadata
let metadata = ReactionMetadata(comment: "Great post!", intensity: 5)
let response = try await cm.social.react(
  eventId: "event-123",
  reactionType: .love,
  metadata: metadata
)
```

### Update/Remove Reactions

```swift
let cm = ContactsService.shared

// Update reaction
let response = try await cm.social.updateReaction(
  eventId: "event-123",
  reactionType: .love  // Changes from previous reaction
)

// Remove reaction
let response = try await cm.social.updateReaction(
  eventId: "event-123",
  reactionType: nil    // Removes the reaction
)

// Direct removal
let response = try await cm.social.removeReaction(eventId: "event-123")
```

### Get Reactions

```swift
let cm = ContactsService.shared

// Get all reactions for an event
let reactions = try await cm.social.getReactions(
  eventId: "event-123",
  skip: 0,
  limit: 50
)

// Get reactions summary with counts
let summary = try await cm.social.getReactionsSummary(eventId: "event-123")
print("Total reactions: \(summary.totalCount)")
print("Likes: \(summary.count(for: .like))")

// Get current user's reaction
let myReaction = try await cm.social.getMyReaction(eventId: "event-123")
if let reaction = myReaction {
  print("I reacted with: \(reaction.displayName) \(reaction.emoji)")
}

// Get specific user's reaction (currently returns current user's reaction)
let userReaction = try await cm.social.getUserReaction(
  eventId: "event-123",
  userId: "user-456"
)
```

### Advanced Features

```swift
let cm = ContactsService.shared

// Get event with complete reaction data
let eventWithReactions = try await cm.social.getEventWithReactions(eventId: "event-123")
print("Event: \(eventWithReactions.event.title)")
print("Total reactions: \(eventWithReactions.reactionsSummary.totalCount)")

// Batch check user reactions (max 50 events)
let eventIds = ["event-1", "event-2", "event-3"]
let batchReactions = try await cm.social.getBatchUserReactions(eventIds: eventIds)

for (eventId, reactionType) in batchReactions {
  if let reaction = reactionType {
    print("Event \(eventId): Reacted with \(reaction.displayName)")
  } else {
    print("Event \(eventId): No reaction")
  }
}
```

### Enhanced Event Queries

```swift
let cm = ContactsService.shared

// Get user events with reactions
let eventsWithReactions = try await cm.social.getUserEvents(
  userId: "user-123",
  includeReactions: true,
  skip: 0,
  limit: 20
)

// Filter events by reaction types
let popularEvents = try await cm.social.getUserEvents(
  userId: "user-123",
  reactionTypes: [.like, .love, .superLike], // Only events with these reactions
  includeReactions: true
)

// Get feed with reactions
let feedWithReactions = try await cm.social.getFeedWithReactions(
  matching: .following,
  eventType: .post,
  includeReactions: true
)
```

## 🎨 UI Integration

The models include helpful properties for UI development:

```swift
// Event reaction properties
if event.hasReactions {
  print("This event has \(event.reactionsCountText) reactions")
}

// Reaction type properties
let reactionType = ReactionType.love
print("\(reactionType.emoji) \(reactionType.displayName)") // "❤️ Love"

// Summary utilities
let summary = eventReactionsSummary
if summary.userHasReacted(with: .like) {
  print("User has liked this event")
}

print("Available reactions: \(summary.availableReactionTypes.map { $0.displayName })")
```

## 🔐 Error Handling

```swift
let cm = ContactsService.shared

do {
  let response = try await cm.social.react(eventId: "event-123", reactionType: .like)
  print("Reaction successful: \(response.wasCreated ? "created" : "updated")")
} catch SocialServiceError.invalidInput(let message) {
  print("Invalid input: \(message)")
} catch APIError.serverError(let statusCode, let message) {
  print("Server error \(statusCode): \(message)")
} catch {
  print("Unexpected error: \(error)")
}
```

## 🧪 Testing & Preview

All models include SwiftUI Canvas previews for rapid UI development:

```swift
#Preview("Reaction Types") {
  // Visual preview of all available reaction types
}

#Preview("Reaction Interface Demo") {
  // Complete reaction system demo interface
}
```

## 🌟 Best Practices

1. **Use Predefined Types**: Prefer predefined reaction types for consistency
2. **Custom Types**: Use custom types sparingly for special features
3. **Batch Operations**: Use batch APIs for checking multiple reactions
4. **Error Handling**: Always handle API errors appropriately
5. **UI Feedback**: Provide immediate visual feedback for reaction changes
6. **Performance**: Cache reaction data when possible using the built-in event reaction fields

## 🎉 Ready to Use!

The reaction system is now fully integrated into the ContactManager Swift SDK and ready for production use. It provides a complete, type-safe way to handle user reactions with excellent performance and developer experience.

Access all reaction functionality through:

```swift
let cm = ContactsService.shared
await cm.social.react(...)
await cm.social.getReactions(...)
// etc.
```

Use the Canvas previews in Xcode to quickly iterate on your reaction UI implementations!

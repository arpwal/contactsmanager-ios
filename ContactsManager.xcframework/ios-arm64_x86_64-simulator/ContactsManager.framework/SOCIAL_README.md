# SocialService Documentation

The `SocialService` class provides a simple interface for interacting with the social features of the ContactsManager API. This includes follow/unfollow functionality and event management.

## Features

### Follow Management
- Follow and unfollow contacts
- Check if you're following a specific contact
- Get your followers and following lists
- Get mutual follows (contacts you follow who also follow you)

### Event Management
- Create, read, update, and delete events
- Get events for specific contacts
- Get a personalized event feed from contacts you follow
- Get upcoming events

## Getting Started

### Initialization

You can initialize the `SocialService` with the shared `APIClient` instance:

```swift
let socialService = SocialService()
```

Or, provide your own `APIClient` instance:

```swift
let apiClient = APIClient(userId: "your-user-id")
let socialService = SocialService(apiClient: apiClient)
```

## Usage Examples

### Follow Management

#### Follow a Contact

```swift
Task {
    do {
        let result = try await socialService.followContact(followedId: "contact-uuid")
        if let alreadyFollowing = result.alreadyFollowing, alreadyFollowing {
            print("You were already following this contact")
        } else if let success = result.success, success {
            print("Successfully followed the contact")
        }
    } catch {
        print("Error following contact: \(error)")
    }
}
```

#### Unfollow a Contact

```swift
Task {
    do {
        let result = try await socialService.unfollowContact(followedId: "contact-uuid")
        if let wasFollowing = result.wasFollowing, wasFollowing {
            print("Successfully unfollowed the contact")
        } else {
            print("You weren't following this contact")
        }
    } catch {
        print("Error unfollowing contact: \(error)")
    }
}
```

#### Check if Following a Contact

```swift
Task {
    do {
        let status = try await socialService.isFollowingContact(followedId: "contact-uuid")
        if status.isFollowing {
            print("You are following this contact")
        } else {
            print("You are not following this contact")
        }
    } catch {
        print("Error checking follow status: \(error)")
    }
}
```

#### Get Your Followers

```swift
Task {
    do {
        // Get first page of followers (20 per page)
        let followers = try await socialService.getFollowers()
        
        print("You have \(followers.total) followers")
        for relationship in followers.items {
            if let follower = relationship.follower {
                print("- \(follower.fullName ?? "Unknown") (\(follower.email ?? "No email"))")
            }
        }
        
        // To get the next page:
        if followers.total > followers.limit {
            let nextPage = try await socialService.getFollowers(skip: followers.limit)
            print("Next page has \(nextPage.items.count) followers")
        }
    } catch {
        print("Error getting followers: \(error)")
    }
}
```

### Event Management

#### Create an Event

```swift
Task {
    do {
        // Create event data
        let eventData = CreateEventRequest(
            eventType: "meeting",
            title: "Coffee Meetup",
            description: "Let's catch up over coffee",
            location: "Starbucks Downtown",
            startTime: Date().addingTimeInterval(86400), // Tomorrow
            endTime: Date().addingTimeInterval(90000),   // Tomorrow + 1 hour
            isPublic: true
        )
        
        let result = try await socialService.createEvent(eventData: eventData)
        if let eventId = result.eventId, let created = result.created, created {
            print("Successfully created event with ID: \(eventId)")
        }
    } catch {
        print("Error creating event: \(error)")
    }
}
```

#### Get an Event

```swift
Task {
    do {
        let event = try await socialService.getEvent(eventId: "event-uuid")
        print("Event: \(event.title)")
        print("Type: \(event.eventType)")
        if let startTime = event.startTime {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            print("When: \(formatter.string(from: startTime))")
        }
    } catch {
        print("Error getting event: \(error)")
    }
}
```

#### Update an Event

```swift
Task {
    do {
        let updateData = UpdateEventRequest(
            title: "Updated Coffee Meetup",
            location: "Different Cafe"
        )
        
        let result = try await socialService.updateEvent(
            eventId: "event-uuid",
            eventData: updateData
        )
        
        if let updated = result.updated, updated {
            print("Successfully updated event")
        }
    } catch {
        print("Error updating event: \(error)")
    }
}
```

#### Delete an Event

```swift
Task {
    do {
        let result = try await socialService.deleteEvent(eventId: "event-uuid")
        if let deleted = result.deleted, deleted {
            print("Successfully deleted event")
        }
    } catch {
        print("Error deleting event: \(error)")
    }
}
```

#### Get Your Event Feed

```swift
Task {
    do {
        let feed = try await socialService.getFeed()
        
        print("Your feed has \(feed.total) events")
        for event in feed.items {
            print("- \(event.title) (\(event.eventType))")
            if let startTime = event.startTime {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                print("  When: \(formatter.string(from: startTime))")
            }
        }
    } catch {
        print("Error getting feed: \(error)")
    }
}
```

#### Get "For You" Feed

```swift
Task {
    do {
        // Get events that aren't limited to people you follow
        let forYouFeed = try await socialService.getForYouFeed()
        
        print("For You feed has \(forYouFeed.total) events")
        for event in forYouFeed.items {
            print("- \(event.title) by \(event.canonicalContactId)")
        }
    } catch {
        print("Error getting For You feed: \(error)")
    }
}
```

## Pagination

All list methods support pagination through the `skip` and `limit` parameters:

```swift
// Get the first page with 20 items
let firstPage = try await socialService.getFollowers(skip: 0, limit: 20)

// Get the second page
let secondPage = try await socialService.getFollowers(skip: 20, limit: 20)
```

## Error Handling

All methods can throw an `APIError` which should be handled appropriately:

```swift
do {
    let result = try await socialService.followContact(followedId: "contact-uuid")
    // Handle success
} catch let error as APIError {
    switch error {
    case .unauthorized:
        // Handle unauthorized access
        print("You need to be logged in")
    case .serverError(let statusCode, let message):
        // Handle server errors
        print("Server error \(statusCode): \(message)")
    case .networkError(let underlyingError):
        // Handle network issues
        print("Network error: \(underlyingError.localizedDescription)")
    default:
        // Handle other API errors
        print("API error: \(error.localizedDescription)")
    }
} catch {
    // Handle other errors
    print("Unexpected error: \(error.localizedDescription)")
}
``` 
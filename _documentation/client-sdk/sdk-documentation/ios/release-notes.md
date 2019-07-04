---
title: Release Notes
description: Release notes. A list of most important fixes and new features for Client SDK.
navigation_weight: 0
---

# Release Notes

## Version 0.3.0 - June 03, 2019

### Added

- Interoperability with the JS and Android SDKs - Calls can now be placed between apps using the iOS, JS or Android SDKs.

### Changed

- `NXMCallMember` - added member channel with direction data

```swift
@interface NXMCallMember : NSObject
...
@property (nonatomic, readonly, nullable) NXMChannel *channel;
...
@end
```

```swift
@interface NXMChannel : NSObject

@property (nonatomic, readonly, nonnull) NXMDirection *from;
@property (nonatomic, readonly, nullable) NXMDirection *to;

@end

```

```swift
@interface NXMDirection : NSObject

@property (nonatomic, assign) NXMDirectionType type;
@property (nonatomic, copy, nullable) NSString *data;

@end
```

### Removed

- `NXMCallMember`'s `phoneNumber` and `channelType` were removed




## Version 0.2.56 - January 24, 2019

### Added
- Change log file.

### Changed
- Memory management improvements.
- Fetch missing and new events on network changes.
- Returning User objects instead of Ids.
- Bug fixes.
- Add non-null or nullable to properties
- Rename call.decline to call.reject


## Version 0.1.52 - January 01, 2019

- Initial beta release with basic call and chat features.

	- Please refer to list of features and usage  
	  https://developer.nexmo.com/

	- **Cocoapods**  
	  https://cocoapods.org/pods/nexmoclient

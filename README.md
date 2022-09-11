<p align="center">
  <img src="https://user-images.githubusercontent.com/1652432/189526292-0ae3b5b7-e565-41f1-86ac-f3c1ffad1e57.png" height="128">
  <h1 align="center">SiriusRating</h1>
</p>

[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-green?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-Green?style=flat-square)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SiriusRating.svg?style=flat-square)](https://img.shields.io/cocoapods/v/SiriusRating.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

<img width="1012" alt="github-banner" src="https://user-images.githubusercontent.com/1652432/189526390-6aee1e21-3350-4eba-99d5-4b82c262f291.png">

A modern utility that reminds your iOS app's users to review the app in a non-invasive way.

## Requirements

- Xcode 11.1+
- iOS 13.0+

## Setup
Configure a SiriusRating shared instance, typically in your App's initializer or app delegate's `application(_:didFinishLaunchingWithOptions:)` method:

### Simple One-line Setup

```swift
// By default uses the following rating conditions:
// [EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
//  EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15),
//  EnoughSignificantEventsRatingCondition(significantEventsRequired: 20),
//  NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),  
//  NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
//  NotRatedCurrentVersionRatingCondition(),
//  NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)]
SiriusRating.setup()
```

### Custom Configuration

```swift
SiriusRating.setup(
    requestPromptPresenter: StyleTwoRequestPromptPresenter(),
    debugEnabled: true,
    ratingConditions: [
        EnoughDaysUsedRatingCondition(totalDaysRequired: 14),
        EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 20),
        EnoughSignificantEventsRatingCondition(significantEventsRequired: 30),
        // Important rating conditions, do not forget these:
        NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 14),
        NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 3),
        NotRatedCurrentVersionRatingCondition(),
        NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)
    ],
    canPromptUserToRateOnLaunch: true,
    didOptInForReminderHandler: {
        analytics.track(.didOptInForReminderToRateApp)
    },
    didDeclineToRateHandler: {
        analytics.track(.didDeclineToRateApp)
    },
    didRateHandler: {
        analytics.track(.didRateApp)
    }
)
```

## Usage

### Significant event
A significant event defines an important event that occurred in your app. In a time tracking app it might be 
that a user registered a time entry. In a game, it might be completing a level.

```swift
SiriusRating.shared.userDidSignificantEvent()
```

### Show request prompt (test purposes only)
To see how the request prompt will look like in your app simply use the following code.

```swift
SiriusRating.shared.showRequestPrompt()
```

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate SiriusRating into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SiriusRating'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate SiriusRating into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "theappcapital/SiriusRating"
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding SiriusRating as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/theappcapital/SiriusRating.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate SiriusRating into your project manually.

## License

SiriusRating is released under the MIT license. [See LICENSE](https://github.com/theappcapital/SiriusRating/blob/master/LICENSE) for details.

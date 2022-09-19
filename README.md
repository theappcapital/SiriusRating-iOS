<p align="center">
  <img src="https://user-images.githubusercontent.com/1652432/189526292-0ae3b5b7-e565-41f1-86ac-f3c1ffad1e57.png" height="128">
  <h1 align="center">SiriusRating</h1>
</p>

[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-green?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-Green?style=flat-square)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SiriusRating.svg?style=flat-square)](https://img.shields.io/cocoapods/v/SiriusRating.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

<img width="1012" alt="github-banner" src="https://user-images.githubusercontent.com/1652432/191008311-aa30638e-864c-42ea-97df-730878300906.png">

A modern utility that reminds your iOS app's users to review the app in a non-invasive way.

## Features

- [x] SwiftUI and UIKit support
- [x] Configurable rating conditions
- [x] Write your own rating conditions to further stimulate positive reviews.
- [x] Modern design 
- [x] Non-invasive approach
- [x] Specification pattern used to build the rating conditions
- [x] Recurring prompts that are configurable using back-off factors
- [x] No need to reset usage trackers each app version
- [x] Option to create your own prompt style
- [x] Unit tested rating conditions
- [x] Show prompt even while dismissing view controllers

## Requirements

- Xcode 11.1+
- iOS 13.0+

## Setup
Configure a SiriusRating shared instance, typically in your App's initializer or app delegate's `application(_:didFinishLaunchingWithOptions:)` method:

### Simple One-line Setup

```swift
SiriusRating.setup()
```

By default the following rating conditions are used:

| Default rating conditions |
| --- |
| `EnoughDaysUsedRatingCondition(totalDaysRequired: 30)` | 
| `EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15)` | 
| `EnoughSignificantEventsRatingCondition(significantEventsRequired: 20)` | 
| `NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7)` | 
| `NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2)` | 
| `NotRatedCurrentVersionRatingCondition()` | 
| `NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)` | 

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
        // analytics.track(.didOptInForReminderToRateApp)
    },
    didDeclineToRateHandler: {
        // analytics.track(.didDeclineToRateApp)
    },
    didRateHandler: {
        // analytics.track(.didRateApp)
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

### Test request prompt 
To see how the request prompt will look like in your app simply use the following code.

```swift
// For test purposes only.
SiriusRating.shared.showRequestPrompt()
```

## Rating conditions
The rating conditions are used to validate if the user can be prompted to rate the app. The validation process happens after the user did a significant event (`userDidSignificantEvent()`). The user will be prompted to rate the app if all rating conditions are satisfied (returning `true`).

| Rating conditions | Description |
| --- | --- |
| `EnoughAppSessionsRatingCondition` | The rating condition that validates if the app has been launched or brought into the foreground enough times. |
| `EnoughDaysUsedRatingCondition` | The rating condition that validates if the app has been used long enough. |
| `EnoughSignificantEventsRatingCondition` | The rating condition that validates whether the user has done enough significant events. |
| `NotDeclinedToRateAnyVersionRatingCondition` | The rating condition that validates that the user didn't decline to rate a version of the app. If the user did decline to rate the app, validate if we can show the prompt again by checking the number of days that have passed after the user's initial decline. |
| `NotPostponedDueToReminderRatingCondition` | The rating condition that validates if the user didn't decline the current version of the app. With this condition we do not want to prompt the user to rate the app again if it declined to rate the current version of the app. |
| `NotPostponedDueToReminderRatingCondition` | The rating condition that validates if the prompt was not postponed due an opted-in reminder. If the user did opt-in for a reminder, it will check if the total number of days have passed to show the prompt again. |
| `NotRatedCurrentVersionRatingCondition` |  The rating condition that checks if the user didn't already rate the current version of the app. We do not want to prompt the user to rate the app again if it already rated this version of the app. |
| `NotRatedAnyVersionRatingCondition` | The rating condition that validates that the user didn't rate any version of the app. If the user did rate the app, validate if we can show the prompt again by checking the number of days that have passed since the user's rated last. |

### Custom rating conditions
You can write your own rating conditions in addition to the current rating conditions to further stimulate positive reviews. 

```swift
class GoodWeatherRatingCondition: RatingCondition {

    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func isSatisfied(dataStore: DataStore) -> Bool {
        // Only show the rating prompt when it's sunny outside.
        return self.weatherRepository.getWeather().isSunny
    }
    
}
```

To make use of the new rating condition simply add it to list.

```swift
SiriusRating.setup(
    ratingConditions: [
        ...,
        GoodWeatherRatingCondition(weatherRepository: WeatherDataRepository())
    ]
)
```

## Customization

### Presenters

| StyleOneRequestPromptPresenter (light, default) | StyleOneRequestPromptPresenter (dark, default) |
| --- | --- |
| ![Style One (light)](https://user-images.githubusercontent.com/1652432/191007601-d2338460-605a-44c1-bb1a-de7079a091ac.png) | ![Style One (dark)](https://user-images.githubusercontent.com/1652432/191007744-f09c8d7e-2085-4258-bf92-807261a96444.png) |

| StyleTwoRequestPromptPresenter (light) | StyleTwoRequestPromptPresenter (dark) |
| --- | --- |
| ![Style Two (light)](https://user-images.githubusercontent.com/1652432/191008227-39384b11-fd1c-4e75-a435-cdb8a4d92a1b.png) | ![Style Two (dark)](https://user-images.githubusercontent.com/1652432/191008116-9bb2e298-cfc1-41fd-99ff-2645a855a9fb.png) |

You can change the presenter to the style you wish.
```swift
SiriusRating.setup(
    requestPromptPresenter: StyleTwoRequestPromptPresenter()
)
```
You can even create your own presenter by extending from `RequestPromptPresenter`.
```swift
class YourCustomStyleRequestPromptPresenter: RequestPromptPresenter {
    
    func show(didAgreeToRateHandler: (() -> Void)?, didOptInForReminderHandler: (() -> Void)?, didDeclineHandler: (() -> Void)?) {
        // Your implementation here. Make sure you call the handlers.
    }
    
}
```
And implement it as follows.
```swift
SiriusRating.setup(
    requestPromptPresenter: YourCustomStyleRequestPromptPresenter()
)
```

### Change texts
You can change the texts by giving the presenter a bundle that contains your custom localized strings.

```swift
SiriusRating.setup(
    requestPromptPresenter: StyleOneRequestPromptPresenter(localizationsBundle: Bundle.main)
)
```

Then you can change the texts in your localizable strings file, for example in: `Localizable.strings`.

```swift
// ...

"request_prompt_title" = "Rate %@";
"request_prompt_duration" = "(duration: less than 10 seconds)";
"request_prompt_description" = "If you enjoy using %@, would you mind taking a moment to rate it? Thanks for your support!";
"request_prompt_rate_button_text" = "Rate %@";
"request_prompt_dont_rate_button_text" = "No, thanks";
"request_prompt_opt_in_for_reminder_button_text" = "Remind me later";
```

### Change tint color
SiriusRating will automatically use the global tint color.
```swift
UIView.appearance().tintColor = .red
```
Or you can set it manually.
```swift
SiriusRating.setup(
    requestPromptPresenter: StyleOneRequestPromptPresenter(tintColor: .red)
)
```

### Change app name
SiriusRating will automatically use the app's display name in the localized texts. If you don't want to use this name you can set it manually.
```swift
SiriusRating.setup(
    requestPromptPresenter: StyleOneRequestPromptPresenter(appName: "App Name")
)
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

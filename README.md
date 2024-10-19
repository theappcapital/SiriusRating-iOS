<p align="center">
  <img src="https://github.com/user-attachments/assets/a9db4fb3-3e8c-4caa-85f4-c74857d135a0" height="128">
  <h1 align="center">SiriusRating iOS</h1>
</p>

<p align="center"> See: https://github.com/theappcapital/SiriusRating-Android for Android.</p>

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftheappcapital%2FSiriusRating-iOS%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/theappcapital/SiriusRating-iOS)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftheappcapital%2FSiriusRating-iOS%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/theappcapital/SiriusRating-iOS)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SiriusRating.svg?style=flat-square)](https://img.shields.io/cocoapods/v/SiriusRating.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)

<img width="1012" alt="github-banner" src="https://github.com/user-attachments/assets/bc28d818-bf8e-4b67-8dd1-1b11d8622f72">

A non-invasive and friendly way to remind users to review and rate an iOS app.

## Features

- [x] Supports 32 languages
- [x] Unit tested
- [x] Dark mode compatibility
- [x] Supports SwiftUI and UIKit
- [x] Configurable rating conditions
- [x] Write your own rating conditions to further stimulate positive reviews.
- [x] Modern, sleek design
- [x] Non-invasive prompts
- [x] Configurable recurring prompts with back-off factors
- [x] Create custom prompt styles

## Requirements
- iOS 13.0+

## Setup
Configure a SiriusRating shared instance, typically in your AppDelegate or your app's initializer.

### Simple One-line Setup

In the ``application(_:didFinishLaunchingWithOptions:)`` function in AppDelegate:
```swift
SiriusRating.setup()
```

For example:
```swift
//...
func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //...
    SiriusRating.setup()

    return true
}
```

By default, the user will be prompted to rate the app when the following conditions are met:

- The app has been `installed for at least 30 days`,
- The user has `opened the app at least 15 times`, and
- The user has `completed 20 significant events`.

If the user selects 'Remind me later,' they will be prompted again after 7 days.
If the user declines the prompt, they will be prompted again after 30 days, with a back-off factor of 2. This means that if the user declines a second time, they will be prompted again in 60 days, a third time in 120 days, and so on.

## Installation

### CocoaPods

To integrate SiriusRating into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SiriusRating'
```

### Carthage

To integrate SiriusRating into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "theappcapital/SiriusRating-iOS"
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/theappcapital/SiriusRating-iOS.git", .upToNextMajor(from: "1.0.8"))
]
```

## Usage

### Significant event
A significant event defines an important event that occurred in your app. In a time tracking app it might be 
that a user registered a time entry. In a game, it might be completing a level.

```swift
SiriusRating.shared.userDidSignificantEvent()
```

SiriusRating will validate the conditions after each significant event and prompt the user if all conditions are satisfied.

### Test request prompt 
To see how the request prompt will look like in your app simply use the following code.

```swift
// For test purposes only.
SiriusRating.shared.showRequestPrompt()
```

## Styles

| StyleOneRequestPromptPresenter (light, default) | StyleOneRequestPromptPresenter (dark, default) |
| --- | --- |
| ![Style One (light)](https://user-images.githubusercontent.com/1652432/191007601-d2338460-605a-44c1-bb1a-de7079a091ac.png) | ![Style One (dark)](https://user-images.githubusercontent.com/1652432/191007744-f09c8d7e-2085-4258-bf92-807261a96444.png) |

| StyleTwoRequestPromptPresenter (light) | StyleTwoRequestPromptPresenter (dark) |
| --- | --- |
| ![Style Two (light)](https://user-images.githubusercontent.com/1652432/191008227-39384b11-fd1c-4e75-a435-cdb8a4d92a1b.png) | ![Style Two (dark)](https://user-images.githubusercontent.com/1652432/191008116-9bb2e298-cfc1-41fd-99ff-2645a855a9fb.png) |

## Rating conditions

The rating conditions are used to validate if the user can be prompted to rate the app. The validation process happens after the user did a significant event (`userDidSignificantEvent()`) or if configured when the app was opened. The user will be prompted to rate the app if all rating conditions are
satisfied (returning `true`).

| Rating Condition                             | Description                                                                                                                                                                                     |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `EnoughAppSessionsRatingCondition`           | Validates whether the app has been launched or brought into the foreground a sufficient number of times.                                                                                        |
| `EnoughDaysUsedRatingCondition`              | Validates whether the app has been in use for a sufficient duration (in days).                                                                                                                  |
| `EnoughSignificantEventsRatingCondition`     | Validates whether the user has completed enough significant events.                                                                                                                             |
| `NotDeclinedToRateAnyVersionRatingCondition` | Validates that the user hasn’t declined to rate any version of the app. If declined, it checks whether enough time has passed since the initial decline before prompting again.                 |
| `NotPostponedDueToReminderRatingCondition`   | Validates whether the user has opted to be reminded later. If so, it checks if the required number of days has passed to prompt again.                                                          |
| `NotRatedCurrentVersionRatingCondition`      | Validates whether the user has already rated the current version of the app. The user won’t be prompted again if they’ve already rated this version.                                            |
| `NotRatedAnyVersionRatingCondition`          | Validates that the user hasn’t rated any version of the app. If the user has previously rated the app, it checks whether enough time has passed since their last rating before prompting again. |

## Customization

### Custom Configuration

```swift
SiriusRating.setup(
    requestPromptPresenter: StyleTwoRequestPromptPresenter(),
    debugEnabled: true,
    ratingConditions: [
        EnoughDaysUsedRatingCondition(totalDaysRequired = 0),
        EnoughAppSessionsRatingCondition(totalAppSessionsRequired = 0),
        EnoughSignificantEventsRatingCondition(significantEventsRequired = 5),
        // Essential rating conditions below: Ensure these are included to prevent the prompt from appearing continuously.
        NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 14),
        NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
        NotRatedCurrentVersionRatingCondition(),
        NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)
    ],
    canPromptUserToRateOnLaunch: true,
    didOptInForReminderHandler: {
        //...
    },
    didDeclineToRateHandler: {
        //...
    },
    didRateHandler: {
        //...
    }
)
```

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
        //...,
        GoodWeatherRatingCondition(weatherRepository: WeatherDataRepository())
    ]
)
```

You can change the presenter to the style you wish.
```swift
SiriusRating.setup(
    requestPromptPresenter: StyleTwoRequestPromptPresenter()
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

## License

SiriusRating is released under the MIT license. [See LICENSE](https://github.com/theappcapital/SiriusRating/blob/master/LICENSE) for details.


//
//  SiriusRating.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 09/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

public class SiriusRating {

    /// The singleton instance. This can only be set by setup().
    private static var _shared: SiriusRating?

    /// The singleton instance of `SiriusRating`.
    public static var shared: SiriusRating {
        if let initializedShared = _shared {
            return initializedShared
        }

        fatalError("[SiriusRating] Singleton not yet initialized. Run setup(ratingCondition:) first.")
    }

    private let debugEnabled: Bool

    /// A private getter for the `debugEnabled` property containing implementation that prevents
    /// accidentally releasing a production app with debug enabled.
    private var _debugEnabled: Bool {
        #if DEBUG
            return self.debugEnabled
        #else
            // Return `false` in a mode that is other than `DEBUG` to prevent accidentally
            // releasing a production app with debug enabled.
            return false
        #endif
    }

    /// Boolean that determines whether we can prompt the user with the request to rate on
    /// launch or when brought into the foreground.
    /// Default => `false`.
    private let canPromptUserToRateOnLaunch: Bool

    /// The callback handler for when a user opted-in for a reminder.
    /// Default => `nil`
    private let didOptInForReminderHandler: (() -> Void)?

    /// The callback handler for when a user declined to rate the app.
    /// Default => `nil`
    private let didDeclineToRateHandler: (() -> Void)?

    /// The callback handler for when a user rated the app.
    /// Default => `nil`
    private let didRateHandler: (() -> Void)?

    /// `SiriusRating` never resets the usage trackers by default. The rating conditions
    /// can be set up in such a way that the user will still be prompted across multiple
    /// app versions. Using the rating conditions rather than resetting the trackers for each (major) app
    /// version is much better, because you can for example set limits (and delays) for the
    /// number of declined rating prompts. A user that keeps declining the rating prompt will
    /// not be bothered after that limit. Therefore preventing making the user angry that might potentially
    /// write a bad review.
    /// Default => `{ _, _ -> return false }`
    private let needsResetTrackers: (DataStore, AppVersionProvider) -> Bool

    /// The rating conditions that are used to determine whether it should show the prompt or not.
    /// Default =>
    /// ```
    ///     [EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
    ///     EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15),
    ///     EnoughSignificantEventsRatingCondition(significantEventsRequired: 20),
    ///     NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),
    ///     NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
    ///     NotRatedCurrentVersionRatingCondition(),
    ///     NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)]
    /// ```.
    private let ratingConditions: [RatingCondition]

    /// A provider that provides the current app version.
    private let appVersionProvider: AppVersionProvider

    /// A data store where we store all counters, significant events, app sessions and performed user actions etc.
    private let dataStore: DataStore

    /// The presenter that is used to show the first prompt; the prompt where we ask if the user wants to rate the app.
    private let requestPromptPresenter: RequestPromptPresenter

    /// The presenter that is used to show the second prompt; the prompt where the user can give stars or leave a review.
    private let ratePresenter: RatePromptPresenter

    /// Determines whether all the defined rating conditions have been met.
    var ratingConditionsHaveBeenMet: Bool {
        guard !self.ratingConditions.isEmpty else {
            self.debugLog("No rating conditions have been found to validate.")
            // We have no rating conditions to validate, return `true`.
            return true
        }

        return self.ratingConditions.allSatisfy { ratingCondition in
            let isRatingConditionValid = ratingCondition.isSatisfied(dataStore: self.dataStore)

            if !isRatingConditionValid {
                self.debugLog("The `\(type(of: ratingCondition))` was not satisfied.")
            }

            return isRatingConditionValid
        }
    }

    // MARK: Init
    
    /// The designated initializer for `SiriusRating`.
    /// - Parameters:
    ///   - appVersionProvider: A provider that provides the current app version.
    ///   - dataStore: A data store where we store all counters, significant events, app sessions and performed user actions etc.
    ///   - requestPromptPresenter: The presenter that is used to show the first prompt; the prompt where we ask if the user wants to rate the app.
    ///   - ratePresenter: The presenter that is used to show the second prompt; the prompt where the user can give stars or leave a review.
    ///   - debugEnabled: Boolean that determines whether we are in debug mode. Default: `false`.
    ///   - ratingConditions: The rating conditions that are used to determine whether it should show the prompt or not.
    ///   - canPromptUserToRateOnLaunch: Boolean that determines whether we can prompt the user with the request to rate on
    ///   launch or when brought into the foreground. Default: `false`.
    ///   - didOptInForReminderHandler: The callback handler for when a user opted-in for a reminder. Default: `nil`.
    ///   - didDeclineToRateHandler: The callback handler for when a user declined to rate the app. Default: `nil`.
    ///   - didRateHandler: The callback handler for when a user rated the app. Default: `nil`.
    ///   - needsResetTrackers: `SiriusRating` never resets the usage trackers by default. The rating conditions
    ///   can be set up in such a way that the user will still be prompted across multiple
    ///   app versions. Using the rating conditions rather than resetting the trackers for each (major) app
    ///   version is much better, because you can for example set limits (and delays) for the
    ///   number of declined rating prompts. A user that keeps declining the rating prompt will
    ///   not be bothered after that limit. Therefore preventing making the user angry that might potentially
    ///   write a bad review.
    public init(
        appVersionProvider: AppVersionProvider,
        dataStore: DataStore,
        requestPromptPresenter: RequestPromptPresenter,
        ratePresenter: RatePromptPresenter,
        debugEnabled: Bool = false,
        ratingConditions: [RatingCondition],
        canPromptUserToRateOnLaunch: Bool = false,
        didOptInForReminderHandler: (() -> Void)? = nil,
        didDeclineToRateHandler: (() -> Void)? = nil,
        didRateHandler: (() -> Void)? = nil,
        needsResetTrackers: @escaping ((DataStore, AppVersionProvider) -> Bool)
    ) {
        self.appVersionProvider = appVersionProvider
        self.dataStore = dataStore
        self.requestPromptPresenter = requestPromptPresenter
        self.ratePresenter = ratePresenter
        self.debugEnabled = debugEnabled
        self.ratingConditions = ratingConditions
        self.canPromptUserToRateOnLaunch = canPromptUserToRateOnLaunch
        self.didOptInForReminderHandler = didOptInForReminderHandler
        self.didDeclineToRateHandler = didDeclineToRateHandler
        self.didRateHandler = didRateHandler
        self.needsResetTrackers = needsResetTrackers

        self.setupObservers()
    }

    /// The convenience (builder) initializer for `SiriusRating`.
    /// - Parameters:
    ///   - appVersionProvider: A provider that provides the current app version. Default: `BundleAppVersionProvider()`.
    ///   - dataStore: A data store where we store all counters, significant events, app sessions and performed user actions etc. Default: `UserDefaultsDataStore()`.
    ///   - requestPromptPresenter: The presenter that is used to show the first prompt; the prompt where we ask if the user wants to rate
    ///   the app. Default: `StyleOneRequestPromptPresenter()`.
    ///   - ratePresenter: The presenter that is used to show the second prompt; the prompt where the user can give stars or leave
    ///   a review. Default: `InAppRatePromptPresenter()`.
    ///   - debugEnabled: Boolean that determines whether we are in debug mode. Default: `false`.
    ///   - ratingConditions: The rating conditions that are used to determine whether it should show the prompt or not. Default:
    ///   ```
    ///   [EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
    ///    EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15),
    ///    EnoughSignificantEventsRatingCondition(significantEventsRequired: 20),
    ///    NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),
    ///    NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
    ///    NotRatedCurrentVersionRatingCondition(),
    ///    NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)]
    ///    ```.
    ///   - canPromptUserToRateOnLaunch: Boolean that determines whether we can prompt the user with the request to rate on
    ///   launch or when brought into the foreground. Default: `false`.
    ///   - didOptInForReminderHandler: The callback handler for when a user opted-in for a reminder. Default: `nil`.
    ///   - didDeclineToRateHandler: The callback handler for when a user declined to rate the app. Default: `nil`.
    ///   - didRateHandler: The callback handler for when a user rated the app. Default: `nil`.
    ///   - needsResetTrackers: `SiriusRating` never resets the usage trackers by default. The rating conditions
    ///   can be set up in such a way that the user will still be prompted across multiple
    ///   app versions. Using the rating conditions rather than resetting the trackers for each (major) app
    ///   version is much better, because you can for example set limits (and delays) for the
    ///   number of declined rating prompts. A user that keeps declining the rating prompt will
    ///   not be bothered after that limit. Therefore preventing making the user angry that might potentially
    ///   write a bad review. Default: `{ _, _ -> return false }`
    public convenience init(
        appVersionProvider: AppVersionProvider? = nil,
        dataStore: DataStore? = nil,
        requestPromptPresenter: RequestPromptPresenter? = nil,
        ratePresenter: RatePromptPresenter? = nil,
        debugEnabled: Bool = false,
        ratingConditions: [RatingCondition]? = nil,
        canPromptUserToRateOnLaunch: Bool = false,
        didOptInForReminderHandler: (() -> Void)? = nil,
        didDeclineToRateHandler: (() -> Void)? = nil,
        didRateHandler: (() -> Void)? = nil,
        needsResetTrackers: ((DataStore, AppVersionProvider) -> Bool)? = nil
    ) {
        // We initialize the defaults here instead of default parameters, because we also have a static setup function: `setup(..)`.
        // If we would use default parameters we would have to duplicate the default values here and in the `setup(..)` function.
        self.init(
            appVersionProvider: appVersionProvider ?? BundleAppVersionProvider(),
            dataStore: dataStore ?? UserDefaultsDataStore(),
            requestPromptPresenter: requestPromptPresenter ?? StyleOneRequestPromptPresenter(),
            ratePresenter: ratePresenter ?? InAppRatePromptPresenter(),
            debugEnabled: debugEnabled,
            ratingConditions: ratingConditions ?? [
                EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
                EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15),
                EnoughSignificantEventsRatingCondition(significantEventsRequired: 20),
                NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),
                NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
                NotRatedCurrentVersionRatingCondition(),
                NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max),
            ],
            canPromptUserToRateOnLaunch: canPromptUserToRateOnLaunch,
            didOptInForReminderHandler: didOptInForReminderHandler,
            didDeclineToRateHandler: didDeclineToRateHandler,
            didRateHandler: didRateHandler,
            needsResetTrackers: needsResetTrackers ?? { _, _ in false }
        )
    }

    /// Setup the observers that track when the app was launched or exited.
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SiriusRating.applicationDidFinishLaunching(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SiriusRating.applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    /// Setup the singleton instance for `SiriusRating`.
    /// - Parameters:
    ///   - appVersionProvider: A provider that provides the current app version. Default: `BundleAppVersionProvider()`.
    ///   - dataStore: A data store where we store all counters, significant events, app sessions and performed user actions etc. Default: `UserDefaultsDataStore()`.
    ///   - requestPromptPresenter: The presenter that is used to show the first prompt; the prompt where we ask if the user wants to rate
    ///   the app. Default: `StyleOneRequestPromptPresenter()`.
    ///   - ratePresenter: The presenter that is used to show the second prompt; the prompt where the user can give stars or leave
    ///   a review. Default: `InAppRatePromptPresenter()`.
    ///   - debugEnabled: Boolean that determines whether we are in debug mode. Default: `false`.
    ///   - ratingConditions: The rating conditions that are used to determine whether it should show the prompt or not. Default:
    ///   ```
    ///   [EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
    ///    EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 15),
    ///    EnoughSignificantEventsRatingCondition(significantEventsRequired: 20),
    ///    NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),
    ///    NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 2),
    ///    NotRatedCurrentVersionRatingCondition(),
    ///    NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max)]
    ///    ```.
    ///   - canPromptUserToRateOnLaunch: Boolean that determines whether we can prompt the user with the request to rate on
    ///   launch or when brought into the foreground. Default: `false`.
    ///   - didOptInForReminderHandler: The callback handler for when a user opted-in for a reminder. Default: `nil`.
    ///   - didDeclineToRateHandler: The callback handler for when a user declined to rate the app. Default: `nil`.
    ///   - didRateHandler: The callback handler for when a user rated the app. Default: `nil`.
    ///   - needsResetTrackers: `SiriusRating` never resets the usage trackers by default. The rating conditions
    ///   can be set up in such a way that the user will still be prompted across multiple
    ///   app versions. Using the rating conditions rather than resetting the trackers for each (major) app
    ///   version is much better, because you can for example set limits (and delays) for the
    ///   number of declined rating prompts. A user that keeps declining the rating prompt will
    ///   not be bothered after that limit. Therefore preventing making the user angry that might potentially
    ///   write a bad review. Default: `{ _, _ -> return false }`
    public static func setup(
        appVersionProvider: AppVersionProvider? = nil,
        dataStore: DataStore? = nil,
        requestPromptPresenter: RequestPromptPresenter? = nil,
        ratePresenter: RatePromptPresenter? = nil,
        debugEnabled: Bool = false,
        ratingConditions: [RatingCondition]? = nil,
        canPromptUserToRateOnLaunch: Bool = false,
        didOptInForReminderHandler: (() -> Void)? = nil,
        didDeclineToRateHandler: (() -> Void)? = nil,
        didRateHandler: (() -> Void)? = nil,
        needsResetTrackers: ((DataStore, AppVersionProvider) -> Bool)? = nil
    ) {
        self._shared = SiriusRating(
            appVersionProvider: appVersionProvider,
            dataStore: dataStore,
            requestPromptPresenter: requestPromptPresenter,
            ratePresenter: ratePresenter,
            debugEnabled: debugEnabled,
            ratingConditions: ratingConditions,
            canPromptUserToRateOnLaunch: canPromptUserToRateOnLaunch,
            didOptInForReminderHandler: didOptInForReminderHandler,
            didDeclineToRateHandler: didDeclineToRateHandler,
            didRateHandler: didRateHandler,
            needsResetTrackers: needsResetTrackers
        )
    }

    // MARK: Notification Handlers

    @objc func applicationDidFinishLaunching(_: Notification) {
        self.userDidLaunchApp()
    }

    @objc func applicationWillEnterForeground(_: Notification) {
        self.userDidLaunchApp()
    }

    // MARK: Public Reset Methods

    public func resetUsageTrackers() {
        self.dataStore.firstUseDate = nil
        self.dataStore.appSessionsCount = 0
        self.dataStore.significantEventCount = 0

        self.debugLog("Resetted usage trackers.")
    }

    public func resetUserActions() {
        self.dataStore.ratedUserActions = []
        self.dataStore.optedInForReminderUserActions = []
        self.dataStore.declinedToRateUserActions = []

        self.debugLog("Resetted user actions.")
    }

    /// Reset all values that are tracked to return to it's initial state.
    public func resetAllTrackers() {
        self.resetUsageTrackers()
        self.resetUserActions()

        self.dataStore.previousOrCurrentAppVersion = nil

        self.debugLog("Resetted all trackers.")
    }

    private func resetTrackersIfNeeded() {
        if self.needsResetTrackers(self.dataStore, self.appVersionProvider) {
            self.resetAllTrackers()
        }
    }

    // MARK: Public Event Methods

    /// Tells `SiriusRating` that the user performed a significant event.
    /// A significant event defines an important event that occurred in your app.
    /// In a time tracking app it might be that a user registered a time entry.
    /// In a game, it might be completing a level.
    ///
    /// - Parameter canPromptUserToRate: If the user has performed enough significant
    /// events and used the app enough, you can suppress the rating alert by passing
    /// `false` for `canPromptUserToRate`. The rating alert will simply be postponed until
    /// it is called again with true for `canPromptUserToRate`.
    public func userDidSignificantEvent(canPromptUserToRate: Bool = true) {
        if canPromptUserToRate {
            self.incrementSignificantEventAndRate()
        } else {
            self.incrementSignificantEventCount()
        }
    }

    func userDidLaunchApp() {
        if self.canPromptUserToRateOnLaunch {
            self.incrementAppSessionsCountAndRate()
        } else {
            self.incrementAppSessionsCount()
        }
    }

    // MARK: Prompts

    func showRequestPrompt() {
        DispatchQueue.main.async {
            self.requestPromptPresenter.show(
                didAgreeToRateHandler: {
                    self.showRatePrompt()

                    // Assume this version is rated. There is no API to tell if the user actually rated.
                    let ratedUserAction = UserAction(appVersion: self.appVersionProvider.appVersion, date: Date())
                    self.dataStore.ratedUserActions.append(ratedUserAction)

                    self.didRateHandler?()
                },
                didOptInForReminderHandler: {
                    let optedInForReminderUserAction = UserAction(appVersion: self.appVersionProvider.appVersion, date: Date())
                    self.dataStore.optedInForReminderUserActions.append(optedInForReminderUserAction)

                    self.didOptInForReminderHandler?()
                },
                didDeclineHandler: {
                    let declinedToRateUserAction = UserAction(appVersion: self.appVersionProvider.appVersion, date: Date())
                    self.dataStore.declinedToRateUserActions.append(declinedToRateUserAction)

                    self.didDeclineToRateHandler?()
                }
            )
        }
    }

    func showRatePrompt() {
        DispatchQueue.main.async {
            self.ratePresenter.show()
        }
    }

    private func showRequestPromptIfConditionsHaveBeenMet() {
        if self.ratingConditionsHaveBeenMet {
            self.debugLog("All rating conditions have been met, show the prompt that requests the user to rate.")

            self.showRequestPrompt()
        }
    }

    /// Called before incrementing the app sessions counter or the significant event counter.
    private func beforeIncrementingUsageCounter() {
        // 1. Check if we need to reset all the trackers. For example: An app publisher may want to reset
        // the usage counters when the app is on a different (new major) version.
        self.resetTrackersIfNeeded()

        // 2. Reset the app version if we are on a different version than the previous stored version.
        if self.dataStore.previousOrCurrentAppVersion != self.appVersionProvider.appVersion {
            self.dataStore.previousOrCurrentAppVersion = self.appVersionProvider.appVersion
        }

        // 3. If the first use date is not (yet) set, set it to 'now'.
        if self.dataStore.firstUseDate == nil {
            self.dataStore.firstUseDate = Date()
        }
    }

    private func incrementAppSessionsCount() {
        self.beforeIncrementingUsageCounter()

        // Increment the app session count.
        self.dataStore.appSessionsCount += 1

        self.debugLog("Incremented app session count to: \(self.dataStore.appSessionsCount).")
        self.debugLog("Currently stored data: \(self.dataStore).")
    }

    private func incrementSignificantEventCount() {
        self.beforeIncrementingUsageCounter()

        // Increment the significant event count.
        self.dataStore.significantEventCount += 1

        self.debugLog("Incremented significant event count to: \(self.dataStore.significantEventCount).")
        self.debugLog("Currently stored data: \(self.dataStore).")
    }

    private func incrementSignificantEventAndRate() {
        self.incrementSignificantEventCount()
        self.showRequestPromptIfConditionsHaveBeenMet()
    }

    private func incrementAppSessionsCountAndRate() {
        self.incrementAppSessionsCount()
        self.showRequestPromptIfConditionsHaveBeenMet()
    }

    // MARK: Debug

    private func debugLog(_ log: String) {
        if self._debugEnabled {
            print("[SiriusRating] \(log)")
        }
    }

}

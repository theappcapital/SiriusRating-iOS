//
//  NotDeclinedToRateAnyVersionRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that validates that the user didn't decline to rate a version of the app. If the user did
/// decline to rate the app, validate if we can show the prompt again by checking the number of days that have passed
/// after the user's initial decline.
public class NotDeclinedToRateAnyVersionRatingCondition: RatingCondition {

    /// If the user declined to rate the app once before we may not want to show the prompt
    /// again for a certain amount of time. We might want to wait a few months before asking again.
    /// This property is the minimum number of days to show the prompt again after the user
    /// declined to rate the app.
    private let daysAfterDecliningToPromptUserAgain: UInt

    /// The back off factor is the number that is used to calculate the (extra) amount of days before
    /// prompting the user again. For example if the value of `daysAfterRatingToPromptUserAgain` is '7'
    /// and `backOffFactor` value is '2.0', it will calculate [7-days, 14-days, 28-days, …] for the accumulating
    /// times the user declined.
    /// Default => `nil`.
    private let backOffFactor: Double?

    /// The maximum number of recurring prompts that is allowed after the user's initial decline.
    /// We do not want to prompt the user an infinite amount of time.
    private let maxRecurringPromptsAfterDeclining: UInt

    /// The calendar that is used to get the total number of days the user last declined.
    /// Default => `Calendar.current`.
    private let calendar: Calendar

    /// Initializer of `EnoughSignificantEventsRatingCondition`.
    /// - Parameters:
    ///   - daysAfterDecliningToPromptUserAgain: If the user declined to rate the app once before we may not want to show the prompt
    ///   again for a certain amount of time. We might want to wait a few months before asking again.
    ///   This property is the minimum amount of days to show the prompt again after the user
    ///   declined to rate the app.
    ///   - backOffFactor: The back off factor is the number that is used to calculate the (extra) amount of days before
    ///   prompting the user again. For example if the value of `daysAfterDecliningToPromptUserAgain` is '7'
    ///   and `backOffFactor` value is '2.0', it will calculate [7-days, 14-days, 28-days, …] for the accumulating
    ///   amount of declines. Default: `nil`.
    ///   - maxRecurringPromptsAfterDeclining: The maximum number of recurring prompts that is allowed after the user's initial decline.
    ///   We do not want to ask the user to rate the app an infinite amount of time.
    ///   - calendar: The calendar that is used to get the total number of days the user last declined. Default: `Calendar.current`.
    public init(
        daysAfterDecliningToPromptUserAgain: UInt,
        backOffFactor: Double? = nil,
        maxRecurringPromptsAfterDeclining: UInt,
        calendar: Calendar = Calendar.current
    ) {
        self.daysAfterDecliningToPromptUserAgain = daysAfterDecliningToPromptUserAgain
        self.backOffFactor = backOffFactor
        self.maxRecurringPromptsAfterDeclining = maxRecurringPromptsAfterDeclining
        self.calendar = calendar
    }

    /// Validate that the user didn't decline to rate a version of the app. If the user did
    /// decline to rate the app, validate if we can show the prompt again by checking the
    /// number of days that have passed after the user's initial decline.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if the user didn't decline any version of the app or if we can show the prompt
    /// again after the user's initial decline, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        let declinedToRateUserActions = dataStore.declinedToRateUserActions
        guard let mostRecentDeclinedToRateUserAction = declinedToRateUserActions.max(by: { $0.date < $1.date }) else {
            // The user didn't decline to rate the app (yet), return `true`.
            return true
        }

        // Minus one, because we want to know how many times the user declined after it initially declined.
        guard (declinedToRateUserActions.count - 1) < self.maxRecurringPromptsAfterDeclining else {
            // We reached the maximum number of declined user actions, we do not want
            // to show the prompt anymore at this point, return `false`.
            return false
        }

        // At this point we know the user declined a prompt, check if we can show the prompt again:

        // 1. Get the total number of days from the date the user declined last until now.
        let lastDateTheUserDeclinedToRateTheApp = mostRecentDeclinedToRateUserAction.date
        let dateNow = Date()
        let totalDaysAfterUserDeclinedLast = self.calendar.dateComponents([.day], from: lastDateTheUserDeclinedToRateTheApp, to: dateNow).day

        // 2. Calculate the number of days it takes to show the prompt again.
        let totalDaysAfterDecliningToPromptUserAgain = self.calculatedTotalDaysToPromptUserAgain(
            daysAfterDecliningToPromptUserAgain: self.daysAfterDecliningToPromptUserAgain,
            backOffFactor: self.backOffFactor,
            timesDeclined: UInt(declinedToRateUserActions.count)
        )

        // 3. Check if the total days after the user last declined is greater than or equal to the total days
        // needed to 'wait' to show the prompt again. For example: The user declined last '3 days' ago and
        // the total days after declining to show the prompt again is '7 days', then the prompt should not
        // be shown, thus returning `false`.
        return totalDaysAfterUserDeclinedLast != nil &&
            totalDaysAfterUserDeclinedLast! >= totalDaysAfterDecliningToPromptUserAgain
    }

    private func calculatedTotalDaysToPromptUserAgain(
        daysAfterDecliningToPromptUserAgain: UInt,
        backOffFactor: Double?,
        timesDeclined: UInt
    ) -> UInt {
        guard let backOffFactor = backOffFactor else {
            return daysAfterDecliningToPromptUserAgain
        }

        // Formula: {days after declining to prompt user again} * ({back off factor} ^ ({times declined - 1}).
        // For example if the `daysAfterDecliningToPromptUserAgain` is '7' and `backOffFactor` is '2.0', it will
        // calculate [7-days, 14-days, 28-days, …] for the accumulating amount of declines.
        return UInt(Double(daysAfterDecliningToPromptUserAgain) * pow(backOffFactor, Double(max(0, Int(timesDeclined) - 1))))
    }

}

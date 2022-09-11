//
//  NotRatedAnyVersionRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 28/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that validates that the user didn't rate any version of the app. If the user did
/// rate the app, validate if we can show the prompt again by checking the number of days that have passed
/// since the user's rated last.
public class NotRatedAnyVersionRatingCondition: RatingCondition {

    /// If the user rated the app once before we may not want to show the prompt
    /// again for a certain amount of time. We might want to wait a few months before asking again.
    /// This property is the minimum number of days to show the prompt again after the user's most
    /// recent rating.
    private let daysAfterRatingToPromptUserAgain: UInt

    /// The back off factor is the number that is used to calculate the (extra) amount of days before
    /// prompting the user again. For example if the value of `daysAfterRatingToPromptUserAgain` is '7'
    /// and `backOffFactor` value is '2.0', it will calculate [7-days, 14-days, 28-days, …] for the accumulating
    /// times the user rated.
    /// Default => `nil`.
    private let backOffFactor: Double?

    /// The maximum number of recurring prompts that is allowed after the user initially rated.
    /// We do not want to prompt the user an infinite amount of time.
    private let maxRecurringPromptsAfterRating: UInt

    /// The calendar that is used to get the total number of days the user last declined.
    /// Default => `Calendar.current`.
    private let calendar: Calendar

    /// Initializer of `NotRatedAnyVersionRatingCondition`.
    /// - Parameters:
    ///   - daysAfterRatingToPromptUserAgain: If the user rated the app once before we may not want to show the prompt
    ///   again for a certain amount of time. We might want to wait a few months before asking again.
    ///   This property is the minimum number of days to show the prompt again after the user's most
    ///   recent rating.
    ///   - backOffFactor: The back off factor is the number that is used to calculate the (extra) amount of days before
    ///   prompting the user again. For example if the value of `daysAfterRatingToPromptUserAgain` is '7'
    ///   and `backOffFactor` value is '2.0', it will calculate [7-days, 14-days, 28-days, …] for the accumulating
    ///   times the user rated. Default: `nil`.
    ///   - maxRecurringPromptsAfterDeclining: The maximum number of recurring prompts that is allowed after the user initially rated.
    ///   We do not want to prompt the user an infinite amount of time.
    ///   - calendar: The calendar that is used to get the total number of days the user last declined. Default: `Calendar.current`.
    public init(
        daysAfterRatingToPromptUserAgain: UInt,
        backOffFactor: Double? = nil,
        maxRecurringPromptsAfterRating: UInt,
        calendar: Calendar = Calendar.current
    ) {
        self.daysAfterRatingToPromptUserAgain = daysAfterRatingToPromptUserAgain
        self.backOffFactor = backOffFactor
        self.maxRecurringPromptsAfterRating = maxRecurringPromptsAfterRating
        self.calendar = calendar
    }

    /// Validate that the user didn't rate any version of the app. If the user did
    /// rate the app, validate if we can show the prompt again by checking the number of days that have passed
    /// since the user's rated last.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if the user didn't rate any version of the app or if we can show the prompt
    ///   again after the user's initially rated, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        let rateUserActions = dataStore.ratedUserActions
        guard let mostRecentRateUserAction = rateUserActions.max(by: { $0.date < $1.date }) else {
            // The user didn't rate the app (yet), return `true`.
            return true
        }

        // Minus one, because we want to know how many times the user rated after it initially rated.
        guard (rateUserActions.count - 1) < self.maxRecurringPromptsAfterRating else {
            // We reached the maximum number of rated user actions, we do not want
            // to show the prompt anymore at this point, return `false`.
            return false
        }

        // At this point we know the user rated a prompt, check if we can show the prompt again:

        // 1. Get the total number of days from the date the user rated last until now.
        let lastDateTheUserRatedTheApp = mostRecentRateUserAction.date
        let dateNow = Date()
        let totalDaysAfterUserRatedLast = self.calendar.dateComponents([.day], from: lastDateTheUserRatedTheApp, to: dateNow).day

        // 2. Calculate the number of days it takes to show the prompt again.
        let totalDaysAfterRatingToPromptUserAgain = self.calculatedTotalDaysToPromptUserAgain(
            daysAfterRatingToPromptUserAgain: self.daysAfterRatingToPromptUserAgain,
            backOffFactor: self.backOffFactor,
            timesRated: UInt(rateUserActions.count)
        )

        // Check if the total days after the user last rated is greater than or equal to the total days
        // needed to 'wait' to show the prompt again. For example: The user rated last '3 days' ago and
        // the total days after rating to show the prompt again is '7 days', then the prompt should not
        // be shown, thus returning `false`.
        return totalDaysAfterUserRatedLast != nil &&
            totalDaysAfterUserRatedLast! >= totalDaysAfterRatingToPromptUserAgain
    }

    private func calculatedTotalDaysToPromptUserAgain(
        daysAfterRatingToPromptUserAgain: UInt,
        backOffFactor: Double?,
        timesRated: UInt
    ) -> UInt {
        guard let backOffFactor = backOffFactor else {
            return daysAfterRatingToPromptUserAgain
        }

        // Formula: {days after rating to prompt user again} * ({back off factor} ^ ({times rated - 1}).
        // For example if the `daysAfterRatingToPromptUserAgain` is '7' and `backOffFactor` is '2.0', it will
        // calculate [7-days, 14-days, 28-days, …] for the accumulating amount of rates.
        return UInt(Double(daysAfterRatingToPromptUserAgain) * pow(backOffFactor, Double(max(0, Int(timesRated) - 1))))
    }

}

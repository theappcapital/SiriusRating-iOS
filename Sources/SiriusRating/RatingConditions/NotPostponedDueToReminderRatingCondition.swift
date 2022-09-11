//
//  RemindMeLaterRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 28/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that validates if the prompt was not postponed due an opted-in reminder. If the user did opt-in
/// for a reminder, it will check if the total number of days have passed to show the prompt again.
public class NotPostponedDueToReminderRatingCondition: RatingCondition {

    /// The total number of days to show the prompt again after the user opted-in for a reminder.
    private let totalDaysBeforeReminding: UInt

    /// The calendar that is used to get the total number of days the user opted-in for a reminder last.
    /// Default => `Calendar.current`.
    private let calendar: Calendar

    /// Initializer of `NotPostponedDueToReminderRatingCondition`.
    /// - Parameters:
    ///   - totalDaysBeforeReminding: The total number of days to show the prompt again after the user opted-in for a reminder.
    ///   - calendar: The calendar that is used to get the total number of days the user opted-in for a reminder last. Default: `Calendar.current`.
    public init(totalDaysBeforeReminding: UInt, calendar: Calendar = Calendar.current) {
        self.totalDaysBeforeReminding = totalDaysBeforeReminding
        self.calendar = calendar
    }

    /// Validate whether the time has come to remind the user to rate the app.
    ///
    /// - Parameter dataStore: Use the data from the store to validate the condition.
    /// - Returns: `true` if the user did not opt-in, or if the user did opted-in for a 'Remind me later' and the time
    /// has come to remind the user. If any of these conditions fail, return `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        // Check if the user opted-in for reminding it later.
        guard let mostRecentRemindMeLaterUserAction = dataStore.optedInForReminderUserActions.max(by: { $0.date < $1.date }) else {
            // The user did not opt-in for the 'Remind me later', return `true` to continue.
            return true
        }

        // Check if the app was used long enough after the user opted-in for the 'Remind me later'.
        let lastDateTheUserOptedInForReminder = mostRecentRemindMeLaterUserAction.date

        let fromDate = lastDateTheUserOptedInForReminder
        let nowDate = Date()
        let totalDaysAfterUserOptedInForReminder = self.calendar.dateComponents([.day], from: fromDate, to: nowDate).day

        return totalDaysAfterUserOptedInForReminder != nil &&
            totalDaysAfterUserOptedInForReminder! >= self.totalDaysBeforeReminding
    }

}

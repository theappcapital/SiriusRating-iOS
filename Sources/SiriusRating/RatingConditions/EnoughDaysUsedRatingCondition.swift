//
//  EnoughDaysUsedRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that validates if the app has been used long enough.
public class EnoughDaysUsedRatingCondition: RatingCondition {

    /// The total number of days the app must be used to satisfy the condition.
    private let totalDaysRequired: UInt

    /// The calendar that is used to get the total number of days the app was used.
    /// Default => `Calendar.current`.
    private let calendar: Calendar

    /// Initializer of `EnoughDaysUsedRatingCondition`.
    /// - Parameters:
    ///   - totalDaysRequired: The total number of days the app must be used to satisfy the condition.
    ///   - calendar:  The calendar that is used to get the total number of days the app was used. Default: `Calendar.current`
    public init(totalDaysRequired: UInt, calendar: Calendar = Calendar.current) {
        self.totalDaysRequired = totalDaysRequired
        self.calendar = calendar
    }

    /// Validate if the app has been used long enough.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if the app was  has been long enough. `false` if the
    /// `firstUseDate` is nil, or when the app was not used long enough.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        guard let firstUseDate = dataStore.firstUseDate else {
            // The `firstUseDate` must exist to make the comparison, return `false`.
            return false
        }

        let nowDate = Date()
        let totalDaysUsed = self.calendar.dateComponents([.day], from: firstUseDate, to: nowDate).day

        return totalDaysUsed != nil &&
            totalDaysUsed! >= self.totalDaysRequired
    }

}

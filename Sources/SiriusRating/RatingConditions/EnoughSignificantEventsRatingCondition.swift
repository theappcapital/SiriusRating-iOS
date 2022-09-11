//
//  EnoughSignificantEventsRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

/// The rating condition that validates whether the user has done enough significant events.
public class EnoughSignificantEventsRatingCondition: RatingCondition {

    /// The total number of significant events that is required to satisfy the condition.
    /// A significant event defines an important event that occurred in your app. In a time tracking app it might be that a
    /// user registered a time entry. In a game, it might be finishing a level.
    private let significantEventsRequired: UInt

    /// Initializer of `EnoughSignificantEventsRatingCondition`.
    /// - Parameter significantEventsRequired: The total number of significant events that is required to satisfy the condition.
    /// A significant event defines an important event that occurred in your app. In a time tracking app it might be that a
    /// user registered a time entry. In a game, it might be finishing a level.
    public init(significantEventsRequired: UInt) {
        self.significantEventsRequired = significantEventsRequired
    }

    /// Validate whether the user has done enough significant events.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if the user has done enough significant events, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        // The total amount of significant events done by the user.
        let significantEventCount = dataStore.significantEventCount

        return significantEventCount >= self.significantEventsRequired
    }
}

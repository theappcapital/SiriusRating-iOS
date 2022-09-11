//
//  EnoughAppSessionsRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

/// The rating condition that validates if the app has been launched or brought into the foreground enough times.
public class EnoughAppSessionsRatingCondition: RatingCondition {

    /// An example of an 'app session' would be if the user launched the app. Bringing
    /// the app into the foreground would also be considered an 'app session'. This property
    /// is the total number of app sessions that is required to satisfy the condition.
    private let totalAppSessionsRequired: UInt

    /// Initializer of `EnoughAppSessionsRatingCondition`.
    /// - Parameter totalAppSessionsRequired: An example of an 'app session' would be if the user launched the app. Bringing
    /// the app into the foreground would also be considered an 'app session'. This property
    /// is the total number of app sessions that is required to satisfy the condition.
    public init(totalAppSessionsRequired: UInt) {
        self.totalAppSessionsRequired = totalAppSessionsRequired
    }

    /// Validate if the app has been launched or brought into the foreground enough times.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if enough app sessions have occurred, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        // The total amount of times the app has been opened.
        let appSessionsCount = dataStore.appSessionsCount

        return appSessionsCount >= self.totalAppSessionsRequired
    }

}

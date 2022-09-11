//
//  RatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

public protocol RatingCondition {

    /// Validate the condition.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` if the condition is valid, else `false`.
    func isSatisfied(dataStore: DataStore) -> Bool

}

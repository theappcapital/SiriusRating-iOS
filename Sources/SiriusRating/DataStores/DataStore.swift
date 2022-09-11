//
//  dataStore.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 09/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The data store that contains all the tracking information.
public protocol DataStore: AnyObject {

    /// The date the first app session took place.
    var firstUseDate: Date? { get set }

    /// The total number of occurred app sessions.
    var appSessionsCount: UInt { get set }

    /// The total number of significant events done by the user.
    var significantEventCount: UInt { get set }

    /// The previous or the current app version that can for example be used to check
    /// if we need to reset the usage trackers on a new app version.
    var previousOrCurrentAppVersion: String? { get set }

    /// A collection of user actions that determines whether and when the user opted-in
    /// for a reminder and on which app version that occurred.
    var optedInForReminderUserActions: [UserAction] { get set }

    /// A collection of user actions that determines whether and when the user rated the app
    /// and on which app version that occurred.
    var ratedUserActions: [UserAction] { get set }

    /// A collection of user actions that determines whether and when the user declined
    /// to rate the app and on which app version that occurred.
    var declinedToRateUserActions: [UserAction] { get set }

}

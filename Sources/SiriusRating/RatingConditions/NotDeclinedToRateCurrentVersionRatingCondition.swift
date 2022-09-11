//
//  NotDeclinedToRateCurrentVersionRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that validates if the user didn't decline the current version of the app.
/// With this condition we do not want to prompt the user to rate the app again if it declined to
/// rate the current version of the app.
public class NotDeclinedToRateCurrentVersionRatingCondition: RatingCondition {

    /// The provider that provides the app version.
    /// Default => `BundleAppVersionProvider(bundle: Bundle.main)`.
    private let appVersionProvider: AppVersionProvider

    /// Initializer of `NotDeclinedToRateCurrentVersionRatingCondition`.
    /// - Parameter appVersionProvider: The provider that provides the app version. Default: `BundleAppVersionProvider(bundle: Bundle.main)`.
    public init(appVersionProvider: AppVersionProvider = BundleAppVersionProvider(bundle: Bundle.main))
    {
        self.appVersionProvider = appVersionProvider
    }

    /// Validate that the user didn't decline the current version of the app.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` when the user didn't decline the current version of the app, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        let declinedToRateUserActions = dataStore.declinedToRateUserActions
        guard !declinedToRateUserActions.isEmpty else {
            // The user didn't decline any rate prompt (yet), return `true`.
            return true
        }

        // The user did decline to rate on a version of the app. Check if the user declined
        // the prompt on the current version of the app.
        let userDeclinedToRateCurrentAppVersion = declinedToRateUserActions.contains(where: { rateUserAction in
            rateUserAction.appVersion == self.appVersionProvider.appVersion
        })

        // Return `true` if the user did not decline the prompt of the current version of the app, else `false`.
        return !userDeclinedToRateCurrentAppVersion
    }

}

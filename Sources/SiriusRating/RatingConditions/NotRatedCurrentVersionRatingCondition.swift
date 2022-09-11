//
//  NotRatedCurrentVersionRatingCondition.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 24/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The rating condition that checks if the user didn't already rate the current version of the app.
/// We do not want to prompt the user to rate the app again if it already rated this version of the app.
public class NotRatedCurrentVersionRatingCondition: RatingCondition {

    /// The provider that provides the app version.
    /// Default => `BundleAppVersionProvider(bundle: Bundle.main)`.
    private let appVersionProvider: AppVersionProvider

    /// Initializer of `NotRatedCurrentVersionRatingCondition`.
    /// - Parameter appVersionProvider: The provider that provides the app version. Default: `BundleAppVersionProvider(bundle: Bundle.main)`.
    public init(appVersionProvider: AppVersionProvider = BundleAppVersionProvider(bundle: Bundle.main))
    {
        self.appVersionProvider = appVersionProvider
    }

    /// Validate whether the user didn't already rate the current version of the app.
    /// - Parameter dataStore: The data store that contains all the tracking information.
    /// - Returns: `true` when the user didn't rate the current version of the app, else `false`.
    public func isSatisfied(dataStore: DataStore) -> Bool {
        let ratedUserActions = dataStore.ratedUserActions
        guard !ratedUserActions.isEmpty else {
            // The user didn't rate the app (yet), return `true`.
            return true
        }

        // The user rated a version of the app:
        // Check if the app version the user rated is equal to the current app version.
        let userRatedCurrentAppVersion = ratedUserActions.contains(where: { rateUserAction in
            rateUserAction.appVersion == self.appVersionProvider.appVersion
        })

        // `true` when the user didn't rate the current version of the app, else `false`.
        return !userRatedCurrentAppVersion
    }

}

//
//  UserDefaultsDataStore.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 10/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

/// The data store that contains all the tracking information using the `UserDefaults` as storage.
public class UserDefaultsDataStore: DataStore, CustomDebugStringConvertible {

    private let firstUseDateKey = "first_use_date"
    private let appSessionsCountKey = "app_sessions_count"
    private let significantEventCountKey = "significant_event_count"
    private let previousOrCurrentAppVersionKey = "previous_or_current_app_version"
    private let optedInForReminderUserActionsKey = "opted_in_for_reminder_user_actions"
    private let ratedUserActionsKey = "rated_user_actions"
    private let declinedToRateUserActionsKey = "declined_to_rate_user_actions"

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    /// The date the first app session took place.
    public var firstUseDate: Date? {
        get {
            guard let value = userDefaults.object(forKey: self.firstUseDateKey) as? Date else {
                return nil
            }

            return value
        }
        set {
            if let value = newValue {
                self.userDefaults.set(value, forKey: self.firstUseDateKey)
            } else {
                self.userDefaults.removeObject(forKey: self.firstUseDateKey)
            }
        }
    }

    /// The total number of occurred app sessions.
    public var appSessionsCount: UInt {
        get {
            guard let value = userDefaults.object(forKey: self.appSessionsCountKey) as? UInt else {
                return 0
            }

            return value
        }
        set {
            self.userDefaults.set(newValue, forKey: self.appSessionsCountKey)
        }
    }

    /// The total number of significant events done by the user.
    public var significantEventCount: UInt {
        get {
            guard let value = userDefaults.object(forKey: self.significantEventCountKey) as? UInt else {
                return 0
            }

            return value
        }
        set {
            self.userDefaults.set(newValue, forKey: self.significantEventCountKey)
        }
    }

    /// The previous or the current app version that can for example be used to check
    /// if we need to reset the usage trackers on a new app version.
    public var previousOrCurrentAppVersion: String? {
        get {
            guard let value = userDefaults.object(forKey: self.previousOrCurrentAppVersionKey) as? String else {
                return nil
            }

            return value
        }
        set {
            if let value = newValue {
                self.userDefaults.set(value, forKey: self.previousOrCurrentAppVersionKey)
            } else {
                self.userDefaults.removeObject(forKey: self.previousOrCurrentAppVersionKey)
            }
        }
    }

    /// A collection of user actions that determines whether and when the user opted-in
    /// for a reminder and on which app version that occurred.
    public var optedInForReminderUserActions: [UserAction] {
        get {
            guard let data = userDefaults.data(forKey: self.optedInForReminderUserActionsKey),
                  let value = try? JSONDecoder().decode([UserAction].self, from: data)
            else {
                return []
            }

            return value
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            self.userDefaults.set(data, forKey: self.optedInForReminderUserActionsKey)
        }
    }

    /// A collection of user actions that determines whether and when the user rated the app
    /// and on which app version that occurred.
    public var ratedUserActions: [UserAction] {
        get {
            guard let data = userDefaults.data(forKey: self.ratedUserActionsKey),
                  let value = try? JSONDecoder().decode([UserAction].self, from: data)
            else {
                return []
            }

            return value
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            self.userDefaults.set(data, forKey: self.ratedUserActionsKey)
        }
    }

    /// A collection of user actions that determines whether and when the user declined
    /// to rate the app and on which app version that occurred.
    public var declinedToRateUserActions: [UserAction] {
        get {
            guard let data = userDefaults.data(forKey: self.declinedToRateUserActionsKey),
                  let value = try? JSONDecoder().decode([UserAction].self, from: data)
            else {
                return []
            }

            return value
        }

        set {
            let data = try? JSONEncoder().encode(newValue)
            self.userDefaults.set(data, forKey: self.declinedToRateUserActionsKey)
        }
    }

    public var debugDescription: String {
        return
            """
            \n    <UserDefaultsDataStore: \(Unmanaged.passUnretained(self).toOpaque())
                    - 'firstUseDate': \(String(describing: self.firstUseDate))
                    - 'appSessionsCount': \(self.appSessionsCount)
                    - 'significantEventCount': \(self.significantEventCount)
                    - 'previousOrCurrentAppVersion': \(String(describing: self.previousOrCurrentAppVersion))
                    - 'optedInForReminderUserActions': \(String(describing: self.optedInForReminderUserActions))
                    - 'ratedUserActions': \(String(describing: self.ratedUserActions))
                    - 'declinedToRateUserActions': \(String(describing: self.declinedToRateUserActions))>
            """
    }

}

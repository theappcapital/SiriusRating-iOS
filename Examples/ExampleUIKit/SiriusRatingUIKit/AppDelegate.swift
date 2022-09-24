//
//  AppDelegate.swift
//  SiriusRatingUIKit
//
//  Created by Thomas Neuteboom on 12/09/2022.
//

import SiriusRating
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SiriusRating.setup(
            debugEnabled: true,
            ratingConditions: [
                // For demo purposes we do not use these rating conditions. They are however recommended for production.
                // EnoughDaysUsedRatingCondition(totalDaysRequired: 30),
                // EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 10),
                // The prompt will trigger when it reached 5 significant events.
                EnoughSignificantEventsRatingCondition(significantEventsRequired: 5),
                NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 14),
                NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 30, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 3),
                NotRatedCurrentVersionRatingCondition(),
                NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 240, maxRecurringPromptsAfterRating: UInt.max),
            ]
        )

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

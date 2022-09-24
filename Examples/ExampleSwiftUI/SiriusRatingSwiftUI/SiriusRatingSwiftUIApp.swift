//
//  SiriusRatingSwiftUIApp.swift
//  SiriusRatingSwiftUI
//
//  Created by Thomas Neuteboom on 15/09/2022.
//

import SiriusRating
import SwiftUI

@main
struct SiriusRatingSwiftUIApp: App {

    init() {
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
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

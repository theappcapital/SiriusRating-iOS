//
//  NotDeclinedToRateAnyVersionRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class NotDeclinedToRateAnyVersionRatingConditionTest: XCTestCase {

    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_user_did_not_decline_to_rate_any_version_of_the_app() throws
    {
        let notDeclinedToRateAnyVersionRatingCondition = NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 180, maxRecurringPromptsAfterDeclining: 1, calendar: Calendar.current)

        // By default the user has not declined the rating prompt.
        // The condition should be satisfied, because the user did not decline the rating prompt.
        XCTAssertTrue(notDeclinedToRateAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Just an extra check: Set the user actions to an empty list (which it should already be by default).
        // Setting it to an empty list means the user has not (yet) declined.
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = []

        // The condition should be satisfied, because the user did not decline.
        XCTAssertTrue(notDeclinedToRateAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_satisfied_when_the_user_did_decline_and_the_days_to_show_prompt_have_passed() throws
    {
        // Create a condition where the user will be prompted again after 180 days when it declined.
        let calendar = Calendar.current
        let notDeclinedToRateAnyVersionRatingCondition = NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 180, maxRecurringPromptsAfterDeclining: 1, calendar: calendar)

        // Set the user actions where the user declined to rate the app 180 days ago (180 days is required to show the prompt again).
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = [UserAction(appVersion: "0.1-anyversion", date: calendar.date(byAdding: .day, value: -180, to: Date())!)]

        // The condition should be satisfied, because the total amount of days (180) have passed since the user declined last.
        XCTAssertTrue(notDeclinedToRateAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_the_max_amount_of_recurring_prompts_was_reached() throws
    {
        let calendar = Calendar.current
        // Create a condition where the user can only be prompted 2 times after it initially got prompted and declined.
        let notDeclinedToRateAnyVersionRatingCondition = NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 10, maxRecurringPromptsAfterDeclining: 2, calendar: calendar)

        // The user already declined 3 times.
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = [
            UserAction(appVersion: "0.1-version", date: calendar.date(byAdding: .day, value: -180, to: Date())!),
            UserAction(appVersion: "0.2-version", date: calendar.date(byAdding: .day, value: -90, to: Date())!),
            UserAction(appVersion: "0.3-version", date: calendar.date(byAdding: .day, value: -20, to: Date())!),
        ]

        // The condition should not be satisfied, because we reached the max amount of recurring prompts (3 is greater than 2).
        XCTAssertFalse(notDeclinedToRateAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_because_user_did_decline_but_the_days_to_show_the_recurring_prompt_have_not_yet_passed() throws
    {
        let calendar = Calendar.current
        // Create a condition where the user can be prompted again after 180 days when it declined.
        let notDeclinedToRateAnyVersionRatingCondition = NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 180, maxRecurringPromptsAfterDeclining: 1, calendar: calendar)

        // The user declined to rate the app 90 days ago (180 days is required to show the prompt again).
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = [UserAction(appVersion: "0.1-anyversion", date: calendar.date(byAdding: .day, value: -90, to: Date())!)]

        // The condition is should not be satisfied; the user did decline to rate, but only a total of 90 days have
        // passed instead of the 180 days required to show the prompt.
        XCTAssertFalse(notDeclinedToRateAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

}

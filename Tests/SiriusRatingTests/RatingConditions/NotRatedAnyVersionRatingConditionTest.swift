//
//  NotRatedAnyVersionRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class NotRatedAnyVersionRatingConditionTest: XCTestCase {

    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_user_did_not_rate_any_version_of_the_app() throws {
        let notRatedAnyVersionRatingCondition = NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 180, maxRecurringPromptsAfterRating: 1, calendar: Calendar.current)

        // By default the user has not rated.
        // The condition should be satisfied, because the user did not rate the app.
        XCTAssertTrue(notRatedAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Just an extra check: Set the user actions to an empty list (which it should already be by default).
        // Setting it to an empty list means the user has not (yet) rated.
        self.inMemorySiriusRatingDataStore.ratedUserActions = []

        // The condition should be satisfied, because the user did not decline.
        XCTAssertTrue(notRatedAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_satisfied_when_the_user_did_rate_and_the_days_to_show_prompt_have_passed() throws
    {
        let calendar = Calendar.current
        // Create a condition where the user can be prompted again after 180 days when it rated.
        let notRatedAnyVersionRatingCondition = NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 180, maxRecurringPromptsAfterRating: 1, calendar: calendar)

        // Set the user actions where the user rated the app 180 days ago (180 days is required to show the prompt again).
        self.inMemorySiriusRatingDataStore.ratedUserActions = [UserAction(appVersion: "0.1-version", date: calendar.date(byAdding: .day, value: -180, to: Date())!)]

        // The condition should be satisfied, because the total amount of days (180) have passed since the user rated last.
        XCTAssertTrue(notRatedAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_the_max_amount_of_recurring_prompts_was_reached() throws
    {
        let calendar = Calendar.current
        // Create a condition where the user can only be prompted 2 times after it initially got prompted and rated.
        let notRatedAnyVersionRatingCondition = NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 10, maxRecurringPromptsAfterRating: 2, calendar: calendar)

        // Set the user actions where the user already rated 3 times.
        self.inMemorySiriusRatingDataStore.ratedUserActions = [
            UserAction(appVersion: "0.1-anyversion", date: calendar.date(byAdding: .day, value: -180, to: Date())!),
            UserAction(appVersion: "0.2-anyversion", date: calendar.date(byAdding: .day, value: -90, to: Date())!),
            UserAction(appVersion: "0.3-anyversion", date: calendar.date(byAdding: .day, value: -20, to: Date())!),
        ]

        // The condition should not be satisfied, because we reached the max amount of recurring prompts (3 is greater than 2).
        XCTAssertFalse(notRatedAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_because_the_amount_of_days_to_show_the_recurring_prompt_have_not_yet_passed() throws
    {
        let calendar = Calendar.current
        // Create a condition where the user can be prompted again after 180 days when it rated.
        let notRatedAnyVersionRatingCondition = NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 180, maxRecurringPromptsAfterRating: 1, calendar: calendar)

        // The user rated the app 90 days ago (180 days is required to show the prompt again).
        self.inMemorySiriusRatingDataStore.ratedUserActions = [UserAction(appVersion: "0.1-anyversion", date: calendar.date(byAdding: .day, value: -90, to: Date())!)]

        // The condition is should not be satisfied; the user rated, but only a total of 90 days have
        // passed instead of the 180 days required to show the prompt.
        XCTAssertFalse(notRatedAnyVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

}

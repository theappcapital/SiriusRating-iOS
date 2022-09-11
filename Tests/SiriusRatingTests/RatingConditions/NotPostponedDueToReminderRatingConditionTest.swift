//
//  NotPostponedDueToReminderRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class NotPostponedDueToReminderRatingConditionTest: XCTestCase {
    
    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_user_did_not_opt_in_for_reminder() throws {
        let remindMeLaterRatingCondition = NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 1)

        // By default the user did not opted-in for a reminder.
        // The condition should be satisfied, because the user did not opt-in for a reminder.
        XCTAssertTrue(remindMeLaterRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Just an extra check: Set the user actions to an empty list (which is should already be by default).
        // Setting it to an empty list means it has not (yet) opted-in for a reminder.
        self.inMemorySiriusRatingDataStore.optedInForReminderUserActions = []

        // The condition should be satisfied, because the user did not opt-in for a reminder.
        XCTAssertTrue(remindMeLaterRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_satisfied_when_the_user_opted_in_for_a_reminder_and_days_before_reminding_was_reached() throws
    {
        let calendar = Calendar.current
        // Create the condition where we set the total days before reminding to 1.
        let remindMeLaterRatingCondition = NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 1, calendar: calendar)

        // Set the action where the user did opt-in for a reminder yesterday.
        let dateTheUserOptedInForAReminder = calendar.date(byAdding: .day, value: -1, to: Date())!
        self.inMemorySiriusRatingDataStore.optedInForReminderUserActions = [UserAction(appVersion: "0.1-anyversion", date: dateTheUserOptedInForAReminder)]

        // The condition should be satisfied, because the user opted-in for a reminder yesterday and the total days
        // before reminding is 1: The date 'today' (now) and yesterday is a 1 day difference.
        XCTAssertTrue(remindMeLaterRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_the_user_opted_in_for_reminder_but_days_before_reminding_was_not_reached() throws
    {
        // Create the condition where we set the total days before reminding to 2.
        let totalDaysBeforeReminding: UInt = 2
        let remindMeLaterRatingCondition = NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: totalDaysBeforeReminding)

        // Create a random date that is 'now' or ((24 * totalDaysBeforeReminding) - 1) hours in the past.
        // For example: If the `totalDaysBeforeReminding` is 2, it will create a date in the past between 0 and 47 hours.
        let dateTheUserOptedInForAReminder = Calendar.current.date(byAdding: .hour, value: -Int.random(in: 0 ... (24 * Int(totalDaysBeforeReminding) - 1)), to: Date())!
        // The user did opt-in for a reminder a few hours in the past.
        self.inMemorySiriusRatingDataStore.optedInForReminderUserActions = [UserAction(appVersion: "0.1-anyversion", date: dateTheUserOptedInForAReminder)]

        // The condition should not be satisfied, because the user opted-in for a reminder between 0 and 47 hours ago and
        // the total days before reminding is 2 (48 hours): The total days before reminding was not (yet) reached.
        XCTAssertFalse(remindMeLaterRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }
    
}

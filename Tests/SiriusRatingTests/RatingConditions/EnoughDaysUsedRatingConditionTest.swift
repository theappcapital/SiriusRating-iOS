//
//  EnoughDaysUsedRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 28/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class EnoughDaysUsedRatingConditionTest: XCTestCase {
    
    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_app_was_used_enough_days() throws {
        // Create the condition where we require the app to be used for at least 2 days.
        let calendar = Calendar.current
        let enoughDaysUsedRatingCondition = EnoughDaysUsedRatingCondition(totalDaysRequired: 2, calendar: calendar)

        // Set the first use date to 3 days ago.
        self.inMemorySiriusRatingDataStore.firstUseDate = calendar.date(byAdding: .day, value: -3, to: Date())!

        // The condition should be satisfied, because the total days required is 2 and the date the app was used
        // for the first time 3 days ago.
        XCTAssertTrue(enoughDaysUsedRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_first_use_date_is_nil() throws {
        let enoughDaysUsedRatingCondition = EnoughDaysUsedRatingCondition(totalDaysRequired: 2, calendar: Calendar.current)

        // Set our first use date to `nil`.
        self.inMemorySiriusRatingDataStore.firstUseDate = nil

        // The condition should not be satisfied, because we require `firstUseDate` to exist.
        XCTAssertFalse(enoughDaysUsedRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_app_was_not_used_enough_days() throws {
        // Create the condition where we require the app to be used for at least 2 days.
        let calendar = Calendar.current
        let enoughDaysUsedRatingCondition = EnoughDaysUsedRatingCondition(totalDaysRequired: 2, calendar: calendar)

        // Set the first use date to 1 days ago.
        self.inMemorySiriusRatingDataStore.firstUseDate = calendar.date(byAdding: .day, value: -1, to: Date())!

        // The condition should not be satisfied, because the total days used required to satisfy is 2 and the date the app was used
        // for the first time was 1 days ago.
        XCTAssertFalse(enoughDaysUsedRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }
    
}

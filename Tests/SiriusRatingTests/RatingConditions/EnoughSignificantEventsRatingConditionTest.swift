//
//  EnoughSignificantEventsRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class EnoughSignificantEventsRatingConditionTest: XCTestCase {
    
    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_significant_event_count_is_equal_or_greater_than_the_required_amount_of_significant_events() throws
    {
        // Create the condition where we require the user to have done at least 5 significant events.
        let enoughSignificantEventsRatingCondition = EnoughSignificantEventsRatingCondition(significantEventsRequired: 5)

        // Set our significant use count to 5, equal to the required significant events (5).
        self.inMemorySiriusRatingDataStore.significantEventCount = 5
        // Condition should be satisfied, because the user has done 5 significant events.
        XCTAssertTrue(enoughSignificantEventsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Set our significant use count to be 6, greater than the required significant events (5).
        self.inMemorySiriusRatingDataStore.significantEventCount = 6
        // The condition should be satisfied, because the user has done 6 significant events.
        XCTAssertTrue(enoughSignificantEventsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_significant_event_count_is_lower_than_the_required_amount_of_significant_events() throws
    {
        // Create the condition where we require the user to have done at least 5 significant events.
        let enoughSignificantEventsRatingCondition = EnoughSignificantEventsRatingCondition(significantEventsRequired: 5)

        // Set our significant use count to 1, lower than the required significant events (5).
        self.inMemorySiriusRatingDataStore.significantEventCount = 1
        // The condition should not be satisfied, because the total amount of significant events done by the
        // user is 1, where 5 or greater is required to be satisfied.
        XCTAssertFalse(enoughSignificantEventsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }
    
}

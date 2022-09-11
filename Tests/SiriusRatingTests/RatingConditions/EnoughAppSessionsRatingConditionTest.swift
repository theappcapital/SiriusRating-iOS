//
//  EnoughAppSessionsRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class EnoughAppSessionsRatingConditionTest: XCTestCase {

    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_app_sessions_count_is_equal_or_greater_than_the_required_app_sessions() throws
    {
        // Create the condition where we require the app to be 'used' 5 times.
        let enoughAppSessionsRatingCondition = EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 5)

        // Set the app sessions count to 5, equal to the required app sessions (5).
        self.inMemorySiriusRatingDataStore.appSessionsCount = 5
        // The condition should be satisfied, because the app was 'used' 5 times.
        XCTAssertTrue(enoughAppSessionsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Set the app sessions count to 6, greater than the required app sessions (5).
        self.inMemorySiriusRatingDataStore.appSessionsCount = 6
        // The condition should be satisfied, because the app was 'used' 6 times.
        XCTAssertTrue(enoughAppSessionsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_when_app_sessions_count_is_lower_than_the_required_app_sessions() throws
    {
        // Create the condition where we require the app to be 'used' 5 times.
        let enoughAppSessionsRatingCondition = EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 5)

        // Set the app sessions count to 1, lower than the required app sessions (5).
        self.inMemorySiriusRatingDataStore.appSessionsCount = 1
        // The condition should not be satisfied, because the total amount of app sessions done by the
        // user is 1, where 5 or greater is required to be satisfied.
        XCTAssertFalse(enoughAppSessionsRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

}

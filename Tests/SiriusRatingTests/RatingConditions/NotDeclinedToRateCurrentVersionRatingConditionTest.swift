//
//  NotDeclinedToRateCurrentVersionRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class NotDeclinedToRateCurrentVersionRatingConditionTest: XCTestCase {
    
    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_user_did_not_decline_to_rate_any_version_of_the_app() throws
    {
        let notDeclinedToRateCurrentVersionRatingCondition = NotDeclinedToRateCurrentVersionRatingCondition(appVersionProvider: InMemoryAppVersionProvider())

        // By default the user has not declined the rating prompt.
        // The condition should be satisfied, because the user did not decline the rating prompt.
        XCTAssertTrue(notDeclinedToRateCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Just an extra check: Set the user actions to an empty list (which it should already be by default).
        // Setting it to an empty list means the user has not (yet) declined.
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = []

        // The condition should be satisfied, because the user did not decline the rating prompt.
        XCTAssertTrue(notDeclinedToRateCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_satisfied_because_the_user_only_declined_a_version_other_than_the_current_version_of_the_app() throws
    {
        let appVersionProvider = InMemoryAppVersionProvider(appVersion: "0.1-currentversion")
        let notDeclinedToRateCurrentVersionRatingCondition = NotDeclinedToRateCurrentVersionRatingCondition(appVersionProvider: appVersionProvider)

        // The user declined to rate a version other than the current version of the app.
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = [UserAction(appVersion: "0.2-otherversionthancurrentversion", date: Date())]

        // The condition should be satisfied because the user did not (yet) decline to rate the current version, but only another version of the app.
        XCTAssertTrue(notDeclinedToRateCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_because_the_user_declined_to_rate_the_current_version_of_the_app() throws
    {
        let appVersionProvider = InMemoryAppVersionProvider()
        let notDeclinedToRateCurrentVersionRatingCondition = NotDeclinedToRateCurrentVersionRatingCondition(appVersionProvider: appVersionProvider)

        // The user declined to rate the current version of the app.
        self.inMemorySiriusRatingDataStore.declinedToRateUserActions = [UserAction(appVersion: appVersionProvider.appVersion, date: Date())]

        // The condition should not be satisfied, because the user declined to rate the current version of the app.
        XCTAssertFalse(notDeclinedToRateCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }
    
}

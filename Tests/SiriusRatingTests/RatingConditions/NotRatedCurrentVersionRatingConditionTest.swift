//
//  NotRatedCurrentVersionRatingConditionTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 01/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class NotRatedCurrentVersionRatingConditionTest: XCTestCase {

    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_condition_is_satisfied_when_the_user_did_not_rate_any_version_of_the_app() throws {
        let notRatedCurrentVersionRatingCondition = NotRatedCurrentVersionRatingCondition(appVersionProvider: InMemoryAppVersionProvider())

        // By default the user has not rated.
        // The condition should be satisfied, because the user did not rate the app.
        XCTAssertTrue(notRatedCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))

        // Just an extra check: Set the user actions to an empty list (which it should already be by default).
        // Setting it to an empty list means the user has not (yet) rated.
        self.inMemorySiriusRatingDataStore.ratedUserActions = []

        // The condition should be satisfied, because the user did not rate.
        XCTAssertTrue(notRatedCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_satisfied_because_the_user_only_rated_a_version_other_than_the_current_version_of_the_app() throws
    {
        let appVersionProvider = InMemoryAppVersionProvider(appVersion: "0.1-currentversion")
        let notRatedCurrentVersionRatingCondition = NotRatedCurrentVersionRatingCondition(appVersionProvider: appVersionProvider)

        // The user rated a version other than the current version of the app.
        self.inMemorySiriusRatingDataStore.ratedUserActions = [UserAction(appVersion: "0.2-otherversionthancurrentversion", date: Date())]

        // The condition should be satisfied because the user did not (yet) rate the current version, but only another version of the app.
        XCTAssertTrue(notRatedCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

    func test_condition_is_not_satisfied_because_the_user_rated_the_current_version_of_the_app() throws
    {
        let appVersionProvider = InMemoryAppVersionProvider()
        let notRatedCurrentVersionRatingCondition = NotRatedCurrentVersionRatingCondition(appVersionProvider: appVersionProvider)

        // The user rated the current version of the app.
        self.inMemorySiriusRatingDataStore.ratedUserActions = [UserAction(appVersion: appVersionProvider.appVersion, date: Date())]

        // The condition should not be satisfied, because the user rated the current version of the app.
        XCTAssertFalse(notRatedCurrentVersionRatingCondition.isSatisfied(dataStore: self.inMemorySiriusRatingDataStore))
    }

}

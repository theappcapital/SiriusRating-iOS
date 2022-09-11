//
//  SiriusRatingTest.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 21/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import XCTest

@testable import SiriusRating

class SiriusRatingTest: XCTestCase {
    
    private var inMemorySiriusRatingDataStore: InMemoryDataStore!

    /// Put setup code here. This method is called before the invocation
    /// of each test method in the class.
    override func setUp() {
        super.setUp()

        self.inMemorySiriusRatingDataStore = InMemoryDataStore()
    }

    func test_that_the_significant_event_count_is_incremented_by_one_when_the_user_did_a_significant_event() throws
    {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // By default the `significantEventCount` should be `0`.
        XCTAssertEqual(self.inMemorySiriusRatingDataStore.significantEventCount, 0)

        SiriusRating.shared.userDidSignificantEvent()

        // The user did a signficant event, the `significantEventCount` should now be `1`.
        XCTAssertEqual(self.inMemorySiriusRatingDataStore.significantEventCount, 1)
    }

    func test_that_the_first_use_date_is_set_when_the_user_did_a_significant_event() throws {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // Be default the `firstUseDate` should be `nil`.
        XCTAssertNil(self.inMemorySiriusRatingDataStore.firstUseDate)

        SiriusRating.shared.userDidSignificantEvent()

        // After the user did a significant event the `firstUseDate` should not be `nil`.
        XCTAssertNotNil(self.inMemorySiriusRatingDataStore.firstUseDate)
    }

    func test_that_the_previous_or_current_app_version_is_set_when_the_user_did_a_significant_event() throws
    {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // Be default the `previousOrCurrentAppVersion` should be `nil`.
        XCTAssertNil(self.inMemorySiriusRatingDataStore.previousOrCurrentAppVersion)

        SiriusRating.shared.userDidSignificantEvent()

        // After the user did a significant event the `previousOrCurrentAppVersion` should not be `nil`.
        XCTAssertNotNil(self.inMemorySiriusRatingDataStore.previousOrCurrentAppVersion)
    }

    func test_that_the_app_sessions_count_is_incremented_by_one_when_the_user_launched_the_app() throws
    {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // By default the `appSessionsCount` should be `0`.
        XCTAssertEqual(self.inMemorySiriusRatingDataStore.appSessionsCount, 0)

        SiriusRating.shared.userDidLaunchApp()

        // The user did launch the app, the `appSessionsCount` should now be `1`.
        XCTAssertEqual(self.inMemorySiriusRatingDataStore.appSessionsCount, 1)
    }

    func test_that_the_first_use_date_is_set_when_the_user_launched_the_app() throws {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // Be default `firstUseDate` should be `nil`.
        XCTAssertEqual(self.inMemorySiriusRatingDataStore.firstUseDate, nil)

        SiriusRating.shared.userDidLaunchApp()

        // The user did launch the app, the `firstUseDate` should now be filled (not `nil`).
        XCTAssertNotNil(self.inMemorySiriusRatingDataStore.firstUseDate)
    }

    func test_that_the_previous_or_current_app_version_is_set_when_the_user_launched_the_app() throws
    {
        SiriusRating.setup(dataStore: self.inMemorySiriusRatingDataStore)

        // Be default the `previousOrCurrentAppVersion` should be `nil`.
        XCTAssertNil(self.inMemorySiriusRatingDataStore.previousOrCurrentAppVersion)

        SiriusRating.shared.userDidLaunchApp()

        // After the user did a significant event the `previousOrCurrentAppVersion` should not be `nil`.
        XCTAssertNotNil(self.inMemorySiriusRatingDataStore.previousOrCurrentAppVersion)
    }
    
}

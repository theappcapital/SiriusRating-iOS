//
//  InMemoryDataStore.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 28/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

@testable import SiriusRating

class InMemoryDataStore: DataStore {
    
    var firstUseDate: Date?

    var appSessionsCount: UInt = 0

    var significantEventCount: UInt = 0

    var previousOrCurrentAppVersion: String?

    var optedInForReminderUserActions: [UserAction] = []

    var ratedUserActions: [UserAction] = []

    var declinedToRateUserActions: [UserAction] = []
    
}

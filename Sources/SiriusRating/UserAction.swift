//
//  UserAction.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 14/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

public struct UserAction: Codable {

    /// The app version the action took place.
    let appVersion: String

    /// The date the action took place.
    let date: Date

}

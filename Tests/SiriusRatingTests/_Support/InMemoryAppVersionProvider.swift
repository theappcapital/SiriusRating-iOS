//
//  InMemoryAppVersionProvider.swift
//  SiriusRatingTests
//
//  Created by Thomas Neuteboom on 14/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

@testable import SiriusRating

class InMemoryAppVersionProvider: AppVersionProvider {

    private let _appVersion: String

    var appVersion: String {
        return self._appVersion
    }

    init(appVersion: String = "0.1-thisisatestversion") {
        self._appVersion = appVersion
    }

}

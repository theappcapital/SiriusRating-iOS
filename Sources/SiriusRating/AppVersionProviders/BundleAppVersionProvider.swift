//
//  BundleAppVersionProvider.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 13/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import Foundation

public class BundleAppVersionProvider: AppVersionProvider {

    private let bundle: Bundle

    public var appVersion: String {
        return self.bundle.bundleVersion
    }

    public init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

}

//
//  ExternalAppleStoreRatePromptPresenter.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 30/08/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

/// The presenter that will open the App Store externally and automatically display the modal view to write a review (with text).
public class ExternalAppleStoreRatePromptPresenter: RatePromptPresenter {

    /// The automatically generated ID assigned to your app. Also known as Apple ID, which
    /// can be found in App Store Connect under 'App Information' of your selected app.
    private let appId: String

    /// Initialize the `ExternalAppleStoreRatePromptPresenter`.
    ///
    /// - Parameter appId: The automatically generated ID assigned to your app. Also known as Apple ID, which
    ///  can be found in App Store Connect under 'App Information' of your selected app.
    public init(appId: String) {
        self.appId = appId
    }

    public func show() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review") else {
            fatalError("Expected a valid URL")
        }

        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }

}

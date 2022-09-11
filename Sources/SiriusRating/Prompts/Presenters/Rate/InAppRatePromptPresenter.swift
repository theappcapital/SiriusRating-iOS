//
//  InAppRatePromptPresenter.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 30/08/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import StoreKit

/// The presenter that will open an in-app prompt to rate the app with stars (without text).
public class InAppRatePromptPresenter: RatePromptPresenter {

    public init() {
        
    }
    
    public func show() {
        SKStoreReviewController.requestReview()
    }

}

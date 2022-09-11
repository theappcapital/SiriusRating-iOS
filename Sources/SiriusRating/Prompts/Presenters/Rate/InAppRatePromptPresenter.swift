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
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }

}

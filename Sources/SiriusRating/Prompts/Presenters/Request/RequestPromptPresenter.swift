//
//  RequestPromptPresenter.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 14/06/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

public protocol RequestPromptPresenter: AnyObject {

    func show(
        didAgreeToRateHandler: (() -> Void)?,
        didOptInForReminderHandler: (() -> Void)?,
        didDeclineHandler: (() -> Void)?
    )

}

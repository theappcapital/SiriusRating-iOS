//
//  StyleOneRequestPromptPresenter.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 30/08/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

public class StyleOneRequestPromptPresenter: RequestPromptPresenter {

    /// Hold a strong reference of the prompt window to prevent it from disappearing automatically.
    private var promptWindow: UIWindow?

    /// The bundle that is used to get the app's name and icon image.
    /// Default => `Bundle.main`
    private let appBundle: Bundle

    /// The bundle that is used to get the localization texts.
    /// Default => `Bundle(identifier: "SiriusRating")`
    private let localizationsBundle: Bundle

    /// The app name that will be used to localize the texts. If the value is `nil` the presenter will
    /// try to find the display name of the app in `appBundle`.
    /// Default => `nil`
    private let appName: String?

    /// Determines whether the presenter should display the 'Remind me later'-button in the prompt.
    /// Default => `true`
    private let canOptInForReminder: Bool

    /// The prompt's tint color. If the value is `nil` the presenter will use the app's global tint color.
    /// Default => `nil`
    private let tintColor: UIColor?

    /// Designated initializer for the `StyleOneRequestPromptPresenter`.
    ///
    /// - Parameters:
    ///   - appBundle: The bundle that is used to get the app's name and icon image. Default: `Bundle.main`.
    ///   - localizationsBundle: The bundle that is used to get the localization texts. Default: `Bundle(identifier: "SiriusRating")`.
    ///   - appName: The app name that will be used to localize the texts. If the value is `nil` the presenter will
    ///   try to find the display name of the app in `appBundle`. Default: `nil`.
    ///   - canOptInForReminder: Determines whether the presenter should display the 'Remind me later'-button in
    ///   the prompt. Default: `true`.
    ///   - tintColor: The prompt's tint color. If the value is `nil` the presenter will use the app's global tint color. Default: `nil`
    public init(
        appBundle: Bundle = Bundle.main,
        localizationsBundle: Bundle? = nil,
        appName: String? = nil,
        canOptInForReminder: Bool = true,
        tintColor: UIColor? = nil
    ) {
        self.appBundle = appBundle
        self.localizationsBundle = localizationsBundle ?? Bundle.moduleOrSelf
        self.appName = appName
        self.canOptInForReminder = canOptInForReminder
        self.tintColor = tintColor
    }

    public func show(
        didAgreeToRateHandler: (() -> Void)? = nil,
        didOptInForReminderHandler: (() -> Void)? = nil,
        didDeclineHandler: (() -> Void)? = nil
    ) {
        if self.promptWindow == nil {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }

            // To make sure the alert view controller is on top of everything we will create a new `UIWindow`.
            let promptWindow = UIWindow(windowScene: windowScene)
            promptWindow.frame = UIScreen.main.bounds
            promptWindow.windowLevel = UIWindow.Level.alert + 1
            promptWindow.rootViewController = UIViewController()
            promptWindow.makeKeyAndVisible()
            self.promptWindow = promptWindow

            let styleOneRequestViewController = StyleOneRequestViewController()
            styleOneRequestViewController.modalTransitionStyle = .crossDissolve
            styleOneRequestViewController.modalPresentationStyle = .overCurrentContext
            styleOneRequestViewController.isDismissableByBackgroundTap = false
            styleOneRequestViewController.appIconImage = self.appBundle.appIcon

            let appName = self.appName ?? self.appBundle.displayName ?? "App"
            styleOneRequestViewController.titleLabel.text = String.localizedStringWithFormat(self.localizationsBundle.localizedString(forKey: "request_prompt_title", value: nil, table: nil), appName)
            styleOneRequestViewController.durationLabel.text = self.localizationsBundle.localizedString(forKey: "request_prompt_duration", value: nil, table: nil)
            styleOneRequestViewController.descriptionLabel.text = String.localizedStringWithFormat(self.localizationsBundle.localizedString(forKey: "request_prompt_description", value: nil, table: nil), appName)
            styleOneRequestViewController.rateButton.setTitle(String.localizedStringWithFormat(self.localizationsBundle.localizedString(forKey: "request_prompt_rate_button_text", value: nil, table: nil), appName), for: .normal)
            styleOneRequestViewController.optInForReminderButton.setTitle(self.localizationsBundle.localizedString(forKey: "request_prompt_opt_in_for_reminder_button_text", value: nil, table: nil), for: .normal)

            styleOneRequestViewController.rateButton.backgroundColor = self.tintColor ?? windowScene.windows.first?.rootViewController?.view.tintColor
            styleOneRequestViewController.optInForReminderButton.isHidden = !self.canOptInForReminder

            styleOneRequestViewController.onDidPressRateButton = { styleOneRequestViewController in
                didAgreeToRateHandler?()
                styleOneRequestViewController.dismiss(animated: true)
            }

            styleOneRequestViewController.onDidPressOptInForReminderButton = { styleOneRequestViewController in
                didOptInForReminderHandler?()
                styleOneRequestViewController.dismiss(animated: true)
            }

            styleOneRequestViewController.onDidPressCloseButton = { styleOneRequestViewController in
                didDeclineHandler?()
                styleOneRequestViewController.dismiss(animated: true)
            }

            styleOneRequestViewController.onDidDisappear = { [weak self] _ in
                // On dismissal of the alert controller we want to remove the alert window from the screen.
                // By removing the reference it will automatically dismiss the window. If we do not dismiss
                // this window it will prevent all user interactions under it.
                self?.promptWindow?.isHidden = true
                self?.promptWindow = nil
            }

            self.promptWindow?.rootViewController?.present(styleOneRequestViewController, animated: true)
        }
    }

}

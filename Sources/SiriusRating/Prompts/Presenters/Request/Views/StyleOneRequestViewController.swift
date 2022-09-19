//
//  StyleOneRequestViewController.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 04/09/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

class StyleOneRequestViewController: UIViewController {

    var onDidDisappear: ((StyleOneRequestViewController) -> Void)?

    var onDidPressRateButton: ((StyleOneRequestViewController) -> Void)?

    var onDidPressOptInForReminderButton: ((StyleOneRequestViewController) -> Void)?

    var onDidPressCloseButton: ((StyleOneRequestViewController) -> Void)?

    /// The dark translucent background behind the content view.
    lazy var darkTranslucentBackground: UIView = {
        let darkTranslucentBackground = UIView()
        darkTranslucentBackground.translatesAutoresizingMaskIntoConstraints = false
        darkTranslucentBackground.backgroundColor = .black.withAlphaComponent(0.3)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapInsideDarkTranslucentBackgroundView))
        darkTranslucentBackground.addGestureRecognizer(tapGestureRecognizer)
        return darkTranslucentBackground
    }()

    /// The white content view containing all the texts and buttons.
    lazy var containerView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterial)
        let contentView = UIVisualEffectView(effect: blurEffect)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemBackground.withAlphaComponent(0.1)
        contentView.layer.cornerRadius = 12
        return contentView
    }()

    /// The image view displaying the app icon.
    private lazy var appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
        appIconImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        appIconImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appIconImageView.contentMode = .scaleAspectFit
        appIconImageView.layer.masksToBounds = true
        return appIconImageView
    }()

    var appIconImage: UIImage? {
        didSet {
            self.appIconImageView.image = appIconImage
            self.appIconImageView.layer.cornerRadius = ((10 / 57) * (appIconImage?.size.height ?? 0))
        }
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                self.appIconImageView,
                self.titleLabel,
                self.durationLabel,
                self.descriptionLabel,
                self.rateButton,
                self.optInForReminderButton,
            ]
        )

        stackView.setCustomSpacing(18.0, after: self.appIconImageView)
        stackView.setCustomSpacing(2.0, after: self.titleLabel)
        stackView.setCustomSpacing(8.0, after: self.durationLabel)
        stackView.setCustomSpacing(14.0, after: self.descriptionLabel)
        stackView.setCustomSpacing(6.0, after: self.rateButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        durationLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        durationLabel.font = .systemFont(ofSize: 14)
        durationLabel.textColor = .label
        durationLabel.textAlignment = .center
        return durationLabel
    }()

    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()

    lazy var rateButton: UIButton = {
        let rateButton = UIButton(type: .system)
        rateButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        rateButton.setContentCompressionResistancePriority(.required, for: .vertical)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        rateButton.backgroundColor = UIColor(red: 0.192, green: 0.594, blue: 0.86, alpha: 1.0)
        rateButton.layer.cornerRadius = 5
        rateButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        rateButton.layer.masksToBounds = true
        rateButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        rateButton.setTitleColor(.white, for: .normal)
        rateButton.addTarget(self, action: #selector(self.didTouchUpInsideRateButton), for: .touchUpInside)
        return rateButton
    }()

    lazy var optInForReminderButton: UIButton = {
        let optInForReminderButton = UIButton(type: .system)
        optInForReminderButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        optInForReminderButton.setContentCompressionResistancePriority(.required, for: .vertical)
        optInForReminderButton.translatesAutoresizingMaskIntoConstraints = false
        optInForReminderButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        optInForReminderButton.titleLabel?.font = .systemFont(ofSize: 15)
        optInForReminderButton.setTitleColor(.secondaryLabel, for: .normal)
        optInForReminderButton.addTarget(self, action: #selector(self.didTouchUpInsideOptInForReminderButton), for: .touchUpInside)
        return optInForReminderButton
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .vertical)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "cross_icon", in: Bundle.moduleOrSelf, compatibleWith: nil), for: .normal)
        closeButton.addTarget(
            self,
            action: #selector(self.didTouchUpInsideCloseButton),
            for: .touchUpInside
        )
        return closeButton
    }()

    /// Boolean that determines whether it may dismiss itself by tapping the background.
    var isDismissableByBackgroundTap: Bool = true

    // MARK: - Initialize

    /// Initializes the view controller.
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    /// Initialize the view controller with coder.
    ///
    /// - Parameter coder: The coder to initialize with.
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    /// View did load is called after instantiation and outlet-setting.
    ///
    /// This is a good place to put a lot of setup code.
    ///
    /// Important: the geometry of the view (it's bounds) is not set yet, so do not
    /// initialize things that are geometry-dependent here. Also, the navigation
    /// controller is not yet set here.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.boot()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.onDidDisappear?(self)
    }

    // MARK: - Boot

    /// The standard boot method for the view. This method will be called by
    /// initialization of the view. Things as adding views and specific changes
    /// to the view can be done here.
    private func boot() {
        self.view.addSubview(self.darkTranslucentBackground)

        self.containerView.contentView.addSubview(self.stackView)
        self.containerView.contentView.addSubview(self.closeButton)
        self.view.addSubview(self.containerView)

        self.setupViewLayoutConstraints()
    }

    /// Setup all the view's layout constraints here.
    private func setupViewLayoutConstraints() {
        NSLayoutConstraint.activate([
            self.appIconImageView.heightAnchor.constraint(equalTo: self.appIconImageView.widthAnchor),
            self.appIconImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            self.appIconImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            self.darkTranslucentBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.darkTranslucentBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.darkTranslucentBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.darkTranslucentBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        ])

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24),
            self.stackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16),
            self.stackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -24),
            self.stackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16),
            self.stackView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            self.closeButton.heightAnchor.constraint(equalToConstant: 44),
            self.closeButton.widthAnchor.constraint(equalToConstant: 44),
            self.closeButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 2),
            self.closeButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -2),
        ])

        NSLayoutConstraint.activate([
            self.rateButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        self.setupViewLayoutConstraintsForTheContentView()
    }

    /// A separate function to setup the view layout constraints for the content
    /// view since it is based on the `preferredContentSize`.
    private func setupViewLayoutConstraintsForTheContentView() {
        NSLayoutConstraint.activate([
            self.containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            self.containerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.containerView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            self.containerView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }

    // MARK: - Selectors

    /// Called whenever the dark translucent background view was tapped.
    @objc private func didTapInsideDarkTranslucentBackgroundView() {
        if self.isDismissableByBackgroundTap {
            self.dismiss(animated: true, completion: nil)
        }
    }

    /// Selector method that is called when the `rateButton` is tapped (`touchUpInside`).
    ///
    /// - Parameter rateButton: The rate button that calls this method.
    @objc private func didTouchUpInsideRateButton(rateButton _: UIButton) {
        self.onDidPressRateButton?(self)
    }

    /// Selector method that is called when the `optInForReminderButton` is tapped (`touchUpInside`).
    ///
    /// - Parameter optInForReminderButton: The opt-in for reminder button that calls this method.
    @objc private func didTouchUpInsideOptInForReminderButton(optInForReminderButton _: UIButton) {
        self.onDidPressOptInForReminderButton?(self)
    }

    /// Selector method that is called when the `closeButton` is tapped (`touchUpInside`).
    ///
    /// - Parameter closeButton: The close button that calls this method.
    @objc private func didTouchUpInsideCloseButton(closeButton _: UIButton) {
        self.onDidPressCloseButton?(self)
    }

}

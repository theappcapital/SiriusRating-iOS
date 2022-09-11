//
//  StyleTwoRequestViewController.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 04/09/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

class StyleTwoRequestViewController: UIViewController {

    var onDidDisappear: ((StyleTwoRequestViewController) -> Void)?

    var onDidPressRateButton: ((StyleTwoRequestViewController) -> Void)?

    var onDidPressOptInForReminderButton: ((StyleTwoRequestViewController) -> Void)?

    var onDidPressCloseButton: ((StyleTwoRequestViewController) -> Void)?

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
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        return contentView
    }()

    /// The image view displaying the app icon.
    private lazy var appIconImageView: UIImageView = {
        let appIconImageView = UIImageView()
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

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(24.0, after: self.appIconImageView)
        stackView.setCustomSpacing(2.0, after: self.titleLabel)
        stackView.setCustomSpacing(12.0, after: self.durationLabel)
        stackView.setCustomSpacing(18.0, after: self.descriptionLabel)
        stackView.setCustomSpacing(8.0, after: self.rateButton)

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.font = .systemFont(ofSize: 14)
        durationLabel.textColor = .black
        durationLabel.textAlignment = .center
        return durationLabel
    }()

    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()

    lazy var rateButton: UIButton = {
        let rateButton = UIButton(type: .system)
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
        optInForReminderButton.translatesAutoresizingMaskIntoConstraints = false
        optInForReminderButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        optInForReminderButton.titleLabel?.font = .systemFont(ofSize: 15)
        optInForReminderButton.setTitleColor(.gray, for: .normal)
        optInForReminderButton.addTarget(self, action: #selector(self.didTouchUpInsideOptInForReminderButton), for: .touchUpInside)

        return optInForReminderButton
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = .darkGray
        closeButton.setImage(UIImage(named: "cross_icon", in: Bundle.module, compatibleWith: nil), for: .normal)
        closeButton.addTarget(
            self,
            action: #selector(self.didTouchUpInsideCloseButton),
            for: .touchUpInside
        )
        return closeButton
    }()

    /// Boolean that determines whether it may dismiss itself by tapping the background.
    var isDismissableByBackgroundTap: Bool = true

    /// The preferred content size of the pop up content view.
    override var preferredContentSize: CGSize {
        didSet {
            self.setupViewLayoutConstraintsForTheContentView()
        }
    }

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

        self.contentView.addSubview(self.stackView)
        self.contentView.addSubview(self.closeButton)
        self.view.addSubview(self.contentView)

        self.setupViewLayoutConstraints()
    }

    /// Setup all the view's layout constraints here.
    private func setupViewLayoutConstraints() {
        NSLayoutConstraint.activate([
            self.darkTranslucentBackground.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.darkTranslucentBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.darkTranslucentBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.darkTranslucentBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
        ])

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 24),
            self.stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -16),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -24),
            self.stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 16),
            self.stackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            self.closeButton.heightAnchor.constraint(equalToConstant: 44),
            self.closeButton.widthAnchor.constraint(equalToConstant: 44),
            self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 2),
            self.closeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2),
        ])

        NSLayoutConstraint.activate([
            self.rateButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        self.setupViewLayoutConstraintsForTheContentView()
    }

    /// A separate function to setup the view layout constraints for the content
    /// view since it is based on the `preferredContentSize`.
    private func setupViewLayoutConstraintsForTheContentView() {
        let widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: self.preferredContentSize.width)
        widthConstraint.priority = UILayoutPriority(500)

        let heightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: self.preferredContentSize.height)
        heightConstraint.priority = UILayoutPriority(500)

        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            widthConstraint,
            heightConstraint,
            self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.contentView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 40),
            self.contentView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20),
            self.contentView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -40),
            self.contentView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 20),
        ])
    }

    // MARK: - Selectors

    /// Called whenever the dark translucent background view was tapped.
    @objc private func didTapInsideDarkTranslucentBackgroundView() {
        if self.isDismissableByBackgroundTap {
            dismiss(animated: true, completion: nil)
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

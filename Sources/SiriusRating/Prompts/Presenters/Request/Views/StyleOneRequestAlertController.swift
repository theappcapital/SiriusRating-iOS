//
//  StyleOneRequestToRateAlertController.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 14/07/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

/// Credits to: https://github.com/stringcode86/AlertViewController for the image above the title using a `UIAlertController`.
class StyleOneRequestAlertController: UIAlertController {

    var onDidDisappear: ((UIAlertController) -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.onDidDisappear?(self)
    }

    /// - Return: value that was set on `title`
    private(set) var originalTitle: String?

    private var spaceAdjustedTitle: String = ""

    private weak var appIconImageView: UIImageView?

    private var previousImgViewSize: CGSize = .zero

    override var title: String? {
        didSet {
            // Keep track of original title
            if self.title != self.spaceAdjustedTitle {
                self.originalTitle = self.title
            }
        }
    }

    /// - parameter image: `UIImage` to be displayed about title label
    func setAppIcon(_ image: UIImage?) {
        guard let imageView = appIconImageView else {
            let imageView = UIImageView(image: image)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = ((10 / 57) * (image?.size.height ?? 0))
            view.addSubview(imageView)
            self.appIconImageView = imageView

            return
        }

        imageView.image = image
    }

    // MARK: -  Layout code

    override func viewDidLayoutSubviews() {
        guard let imageView = appIconImageView else {
            super.viewDidLayoutSubviews()
            return
        }

        // Adjust title if image size has changed
        if self.previousImgViewSize != imageView.bounds.size {
            self.previousImgViewSize = imageView.bounds.size
            self.adjustTitle(for: imageView)
        }

        // Position `imageView`
        let linesCount = self.newLinesCount(for: imageView)
        let padding = Constants.padding(for: preferredStyle)
        imageView.center.x = view.bounds.width / 2.0
        imageView.center.y = padding + linesCount * self.lineHeight / 2.0
        imageView.bounds.size.width = min(imageView.image?.size.width ?? 60, 60)
        imageView.bounds.size.height = min(imageView.image?.size.height ?? 60, 60)

        super.viewDidLayoutSubviews()
    }

    /// Adds appropriate number of "\n" to `title` text to make space for `imageView`
    private func adjustTitle(for imageView: UIImageView) {
        let linesCount = Int(newLinesCount(for: imageView))
        let lines = (0 ..< linesCount).map { _ in "\n" }.reduce("", +)

        self.spaceAdjustedTitle = lines + (self.originalTitle ?? "")
        self.title = self.spaceAdjustedTitle
    }

    /// - Return: Number new line chars needed to make enough space for `imageView`
    private func newLinesCount(for imageView: UIImageView) -> CGFloat {
        return ceil(imageView.bounds.height / self.lineHeight)
    }

    /// Calculated based on system font line height
    private lazy var lineHeight: CGFloat = {
        let style: UIFont.TextStyle = self.preferredStyle == .alert ? .headline : .callout
        return UIFont.preferredFont(forTextStyle: style).pointSize
    }()

    enum Constants {
        static var paddingAlert: CGFloat = 22
        static var paddingSheet: CGFloat = 11

        static func padding(for style: UIAlertController.Style) -> CGFloat {
            return style == .alert ? Constants.paddingAlert : Constants.paddingSheet
        }
    }

}

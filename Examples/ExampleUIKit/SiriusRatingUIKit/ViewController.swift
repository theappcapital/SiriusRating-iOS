//
//  ViewController.swift
//  SiriusRatingUIKit
//
//  Created by Thomas Neuteboom on 12/09/2022.
//

import Combine
import SiriusRating
import UIKit

class ViewModel: ObservableObject {

    private let siriusRating: SiriusRating

    @Published private(set) var significantEventsCount: UInt

    init(siriusRating: SiriusRating = SiriusRating.shared) {
        self.siriusRating = siriusRating
        self.significantEventsCount = siriusRating.dataStore.significantEventCount
    }

    func userDidSignificantEvent() {
        self.siriusRating.userDidSignificantEvent()
        self.significantEventsCount = self.siriusRating.dataStore.significantEventCount
    }

    func resetAllUsageTrackers() {
        self.siriusRating.resetAllTrackers()
        self.significantEventsCount = self.siriusRating.dataStore.significantEventCount
    }

}

class ViewController: UIViewController {

    private let viewModel = ViewModel()

    private var cancellableBag = Set<AnyCancellable>()

    @IBOutlet private var triggerSignificantEventButton: UIButton!

    @IBOutlet private var significantEventsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupViewBindings()
    }

    func setupViewBindings() {
        self.viewModel.$significantEventsCount.sink { [weak self] significantEventsCount in
            self?.significantEventsLabel.text = "Significant events: \(significantEventsCount)"
        }.store(in: &self.cancellableBag)
    }

    @IBAction func didTouchUpInsideTriggerSignificantEventButton(_: UIButton) {
        self.viewModel.userDidSignificantEvent()
    }

    @IBAction func didTouchUpInsideResetAllUsageTrackersButton(_: UIButton) {
        self.viewModel.resetAllUsageTrackers()
    }

    @IBAction func didTouchUpInsideTestRequestPrompt(_: UIButton) {
        SiriusRating.shared.showRequestPrompt()
    }

}

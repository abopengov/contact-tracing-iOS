import Foundation
import UIKit

class CaseHighlightsView: UIView {
    @IBOutlet private var caseHighlightsLabel: UILabel!
    @IBOutlet private var caseHighlightsDescriptionLabel: UILabel!

    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    override func layoutSubviews() {
        super.layoutSubviews()

        caseHighlightsLabel.setLabel(with: homeCaseHighlight, using: .whiteTitleText)
        caseHighlightsDescriptionLabel.setLabel(with: homeCaseHighlightContent, using: .whiteDescriptionText)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bannerPressed(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func bannerPressed(_ sender: Any) {
        homeViewControllerDelegate?.switchTab(.stats)
    }
}

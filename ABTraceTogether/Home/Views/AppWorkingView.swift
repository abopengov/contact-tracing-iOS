import Foundation
import UIKit

class AppWorkingView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var cardView: UIView!
    @IBOutlet private var bumpView: UIView!
    @IBOutlet private var appWorkingLabel: UILabel!
    @IBOutlet private var learnHowItWorksLabel: UILabel!
    @IBOutlet private var bufferViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var appWorkingIcon: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()

        bufferViewHeightConstraint.constant = UIApplication.shared.statusBarFrame.size.height

        appWorkingLabel.setLabel(with: homeAppIsWorking, using: .whiteBigTitleText)
        let appWorkingIconTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugScreen(_:)))
        appWorkingIcon.addGestureRecognizer(appWorkingIconTapGestureRecognizer)
        let learnHowItWorksTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(learnHowItWorksTapped(_:)))
        learnHowItWorksLabel.addGestureRecognizer(learnHowItWorksTapGestureRecognizer)
        learnHowItWorksLabel.setLabel(with: homeLearnHowItWorks, using: .blueLinkText)

        cardView.layer.cornerRadius = 30
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardView.layer.shadowOffset = CGSize(width: 0, height: -1)
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 1

        let bezierPath = UIBezierPath()
        let radius = bumpView.bounds.width / 2
        bezierPath.addArc(
            withCenter: CGPoint(
                x: bumpView.bounds.size.width / 2,
                y: bumpView.bounds.size.height + (radius - bumpView.bounds.height)
            ),
            radius: radius,
            startAngle: 0,
            endAngle: .pi,
            clockwise: false
        )

        let circleShape = CAShapeLayer()
        circleShape.path = bezierPath.cgPath
        bumpView.layer.mask = circleShape
    }

    @objc
    private func openDebugScreen(_ sender: Any) {
        #if DEBUG
        homeViewControllerDelegate?.presentDebugMode()
        #endif
    }

    @objc
    private func learnHowItWorksTapped(_ sender: Any) {
        homeViewControllerDelegate?.switchTab(.faq)
    }
}

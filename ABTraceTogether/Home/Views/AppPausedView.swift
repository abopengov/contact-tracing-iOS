import Foundation
import UIKit

class AppPausedView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var cardView: UIView!
    @IBOutlet private var bumpView: UIView!
    @IBOutlet private var appPausedLabel: UILabel!
    @IBOutlet private var pausedUntilLabel: UILabel!
    @IBOutlet private var resumeDetectionLabel: UILabel!
    @IBOutlet private var bufferViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var appPausedIcon: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()

        bufferViewHeightConstraint.constant = UIApplication.shared.statusBarFrame.size.height

        appPausedLabel.setLabel(with: homePauseDetectionPaused, using: .whiteBigTitleText)
        let appPausedIconTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openDebugScreen(_:)))
        appPausedIcon.addGestureRecognizer(appPausedIconTapGestureRecognizer)

        let resumeDetectionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resumeDetectionTapped(_:)))
        resumeDetectionLabel.addGestureRecognizer(resumeDetectionTapGestureRecognizer)
        resumeDetectionLabel.setLabel(with: homePauseResume, using: .purpleLinkText)

        updatePauseEndTime()

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

    func updatePauseEndTime() {
        if let pauseEndTime = PauseScheduler.shared.endTime {
            let untilText = "\(homePauseUntil.localize()) \(pauseEndTime.getHourMinuteString())"
            pausedUntilLabel.setLabel(with: untilText, using: .whiteSubtitleText, localize: false)
        }
    }

    @objc
    private func openDebugScreen(_ sender: Any) {
        #if DEBUG
        homeViewControllerDelegate?.presentDebugMode()
        #endif
    }

    @objc
    private func resumeDetectionTapped(_ sender: Any) {
        let pauseScheduler = PauseScheduler.shared
        pauseScheduler.pauseTimeSet = false
        pauseScheduler.togglePause()
        pauseScheduler.cancel()
        homeViewControllerDelegate?.refreshHomeScreen()
    }
}

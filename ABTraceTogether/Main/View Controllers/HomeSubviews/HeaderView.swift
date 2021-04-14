import IBMMobileFirstPlatformFoundation
import Lottie
import UIKit

class HeaderView: UIView {
    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var headerMessageLabel: UILabel!
    @IBOutlet private var lastUpdatedLabel: UILabel!
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var animationView: AnimationView!
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.setLabel(
            with: homeHeader,
            using: .h2
        )
        headerLabel.textAlignment = .left
        headerMessageLabel.setLabel(
            with: homeHeaderMessage,
            using: .body
        )
        headerMessageLabel.textAlignment = .left
        if let versionLabelString = versionLabelString {
            versionLabel.setLabel(
                with: versionLabelString,
                using: .body,
                localize: false
            )
            versionLabel.textAlignment = .left
            versionLabel.isHidden = false
        } else {
            versionLabel.isHidden = true
        }
        animationView.loopMode = LottieLoopMode.playOnce
        animationView.play()
    }
}
extension HeaderView: HeaderViewDelegate {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    func updateLastUpdatedTime(_ date: Date) {
        let localizedLastUpdatedText = NSLocalizedString(
            lastUpdated,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[lastUpdated] ?? "",
            comment: ""
        )
        lastUpdatedLabel.text = "\(localizedLastUpdatedText)\(formatDate(date))"
    }
    func playAnimation() {
        animationView.play()
    }
}

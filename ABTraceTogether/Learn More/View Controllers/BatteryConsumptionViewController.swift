import UIKit

class BatteryConsumptionViewController: UIViewController {
    @IBOutlet private var batteryConsumptionLabel: UILabel!
    @IBOutlet private var batteryConsumptionCardContainer: UIView!
    @IBOutlet private var batteryConsumptionImageView: UIImageView!
    @IBOutlet private var batteryConsumptionDetailsLabel: UILabel!
    @IBOutlet private var pauseScheduleTitleLabel: UILabel!
    @IBOutlet private var pauseScheduleDetailsLabel: UILabel!
    @IBOutlet private var gotoPauseScheduleImageView: UIImageView!
    @IBOutlet private var gotoPauseScheduleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        batteryConsumptionLabel.setLabel(with: batteryConsumptionTitle, using: .blackTitleText)

        if let resizedImage = batteryConsumptionImageView.image?.resizeTopAlignedToFill(newWidth: batteryConsumptionCardContainer.frame.width) {
            batteryConsumptionImageView.image = resizedImage
        }
        batteryConsumptionDetailsLabel.setLabel(with: batteryConsumptionDetails, using: .grayDescriptionCenteredText)

        pauseScheduleTitleLabel.setLabel(with: pauseTitle, using: .graySubtitleText)
        pauseScheduleDetailsLabel.setLabel(with: pauseDescription, using: .grayDescriptionText)
        gotoPauseScheduleLabel.setLabel(with: homePauseSetSchedule, using: .graySubtitleText)
        gotoPauseScheduleLabel.underline()

        let tapPauseIconGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pausePressed(_:)))
        self.gotoPauseScheduleImageView.addGestureRecognizer(tapPauseIconGestureRecognizer)

        let tapPauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pausePressed(_:)))
        self.gotoPauseScheduleLabel.addGestureRecognizer(tapPauseGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    @objc
    private func pausePressed(_ sender: Any) {
        let pauseViewController = UIStoryboard(name: "Pause", bundle: nil).instantiateViewController(withIdentifier: "pauseStart")
        pauseViewController.modalPresentationStyle = .fullScreen
        present(pauseViewController, animated: true, completion: nil)
    }
}

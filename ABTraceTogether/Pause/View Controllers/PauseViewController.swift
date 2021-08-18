import UIKit

class PauseViewController: UIViewController {
    @IBOutlet private var returnHomeButton: UIBarButtonItem!
    @IBOutlet private var pauseTitleLabel: UILabel!
    @IBOutlet private var pauseDescriptionLabel: UILabel!
    @IBOutlet private var scheduleLabel: UILabel!
    @IBOutlet private var setTimeSwitch: UISwitch!
    @IBOutlet private var setTimeView: UIView!
    @IBOutlet private var timeScheduleView: UIView!
    @IBOutlet private var setTimeDetailsLabel: UILabel!
    @IBOutlet private var startTimeLabel: UILabel!
    @IBOutlet private var endTimeLabel: UILabel!
    @IBOutlet private var startTimeValueLabel: UILabel!
    @IBOutlet private var endTimeValueLabel: UILabel!
    @IBOutlet private var editButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        returnHomeButton.title = backButtonString.localize()
        pauseTitleLabel.setLabel(with: pauseTitle, using: .blackTitleText)
        pauseDescriptionLabel.setLabel(with: pauseDescription, using: .grayDescriptionText)
        scheduleLabel.setLabel(with: pauseSchedule, using: .graySubtitleText)
        startTimeLabel.setLabel(with: pauseStartTime, using: .graySubtitleText)
        endTimeLabel.setLabel(with: pauseEndTime, using: .graySubtitleText)

        setTimeSwitch.setOn(PauseScheduler.shared.pauseTimeSet, animated: false)
        setTimeSwitch.addTarget(self, action: #selector(setTimeSwitchChanged), for: UIControl.Event.valueChanged)
        editButton.setButton(with: pauseEdit, and: .none, buttonStyle: .settings)

        updateTimeScheduleView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true

        updateTimeRange()
    }

    @IBAction private func returnToHomeScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    public func updateTimeRange() {
        startTimeValueLabel.setLabel(
            with: PauseScheduler.shared.startTime?.getHourMinuteString() ?? "",
            using: .blackDescriptionCenteredText,
            localize: false
        )
        endTimeValueLabel.setLabel(
            with: PauseScheduler.shared.endTime?.getHourMinuteString() ?? "",
            using: .blackDescriptionCenteredText,
            localize: false
        )
    }

    @objc
    private func setTimeSwitchChanged(_: UISwitch) {
        updateTimeScheduleView()
    }

    private func updateTimeScheduleView() {
        let pauseScheduler = PauseScheduler.shared

        if setTimeSwitch.isOn {
            timeScheduleView.isHidden = false
            pauseScheduler.pauseTimeSet = true
        } else {
            timeScheduleView.isHidden = true
            pauseScheduler.pauseTimeSet = false
        }

        pauseScheduler.togglePause()
        if (pauseScheduler.pauseTimeSet) {
            pauseScheduler.schedule()
        } else {
            pauseScheduler.cancel()
        }
    }
}

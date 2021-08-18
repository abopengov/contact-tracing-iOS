import UIKit

class PauseTimeViewController: UIViewController {
    let minuteInterval = 10
    let maxValidTimeInterval = 8.0 * 60 * 60

    @IBOutlet private var cancelButton: UIBarButtonItem!
    @IBOutlet private var saveButton: UIBarButtonItem!
    @IBOutlet private var startTimeLabel: UILabel!
    @IBOutlet private var endTimeLabel: UILabel!
    @IBOutlet private var startTimeTextField: UITextField!
    @IBOutlet private var endTimeTextField: UITextField!
    @IBOutlet private var infoImageView: UIImageView!
    @IBOutlet private var infoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true
        title = pauseSchedule.localize()

        cancelButton.title = cancelString.localize()
        saveButton.title = pauseSave.localize()
        startTimeLabel.setLabel(with: pauseStartTime, using: .graySubtitleText)
        endTimeLabel.setLabel(with: pauseEndTime, using: .graySubtitleText)
        infoLabel.setLabel(with: pauseInfo, using: .grayDescriptionText)

        startTimeTextField.datePicker(
            target: self,
            doneAction: #selector(setStartTimeAction),
            cancelAction: #selector(cancelDatePickerAction),
            mode: .time,
            minuteInterval: minuteInterval
        )

        endTimeTextField.datePicker(
            target: self,
            doneAction: #selector(setEndTimeAction),
            cancelAction: #selector(cancelDatePickerAction),
            mode: .time,
            minuteInterval: minuteInterval
        )

        startTimeTextField.setTime(time: PauseScheduler.shared.startTime)
        endTimeTextField.setTime(time: PauseScheduler.shared.endTime)
    }

    @IBAction private func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func saveTapped(_ sender: Any) {
        if (validateTimeRange() && saveTimeRange()) {
            if let pauseViewController = (presentingViewController as? UINavigationController)?.viewControllers.first {
                (pauseViewController as? PauseViewController)?.updateTimeRange()
            }

            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: pauseErrorDialogTitle.localize(),
                message: pauseErrorDialogMessage.localize(),
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: okString.localize().uppercased(), style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

    @objc
    func cancelDatePickerAction() {
        startTimeTextField.resignFirstResponder()
        endTimeTextField.resignFirstResponder()
    }

    @objc
    func setStartTimeAction() {
        if let datePickerView = startTimeTextField.inputView as? UIDatePicker {
            startTimeTextField.setTime(time: datePickerView.date)
            startTimeTextField.resignFirstResponder()
            updateInfoText()
        }
    }

    @objc
    func setEndTimeAction() {
        if let datePickerView = endTimeTextField.inputView as? UIDatePicker {
            endTimeTextField.setTime(time: datePickerView.date)
            endTimeTextField.resignFirstResponder()
            updateInfoText()
        }
    }

    private func validateTimeRange() -> Bool {
        if let startTime = startTimeTextField.getDate(),
            var endTime = endTimeTextField.getDate() {
            if startTime > endTime,
                let adjustedEndTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime) {
                endTime = adjustedEndTime
            }

            if endTime.timeIntervalSince(startTime) <= maxValidTimeInterval {
                return true
            }
        }
        return false
    }

    private func updateInfoText() {
        if validateTimeRange() {
            infoImageView.image = UIImage(named: "InfoGrey")
            infoLabel.textColor = Colors.DarkGrey
        } else {
            infoImageView.image = UIImage(named: "InfoRed")
            infoLabel.textColor = Colors.ErrorRed
        }
    }

    private func saveTimeRange() -> Bool {
        if let startTime = startTimeTextField.getDate(),
            let endTime = endTimeTextField.getDate() {
            PauseScheduler.shared.startTime = startTime
            PauseScheduler.shared.endTime = endTime
            PauseScheduler.shared.togglePause()
            PauseScheduler.shared.schedule()
            return true
        } else {
            return false
        }
    }
}

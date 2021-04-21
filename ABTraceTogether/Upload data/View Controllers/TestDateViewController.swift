import Foundation
import UIKit

class TestDateViewController: UIViewController {
    @IBOutlet private var testDateLabel: UILabel!
    @IBOutlet private var testDateTextField: UITextField!
    @IBOutlet private var symptomsDateLabel: UILabel!
    @IBOutlet private var symptomsDateTextField: UITextField!
    @IBOutlet private var symptomsToggleLabel: UILabel!
    @IBOutlet private var symptomsSwitch: UISwitch!
    @IBOutlet private var nextButton: UIButton!

    var contactTracerFlow: Bool = false

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let testDate = testDateTextField.getDate() else {
            return
        }

        let symptomsDate = symptomsSwitch.isOn ? symptomsDateTextField.getDate() : nil
        let covidTestData = CovidTestData(testDate: testDate, symptomsDate: symptomsDate)

        if segue.identifier == "ctFlowStep1Segue" {
            if let destinationVC = segue.destination as? UploadDataStep1VC {
                destinationVC.covidTestData = covidTestData
            }
        } else if segue.identifier == "mhrFlowStep2Segue" {
            if let destinationVC = segue.destination as? UploadDataStep2VC {
                destinationVC.covidTestData = covidTestData
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        testDateLabel.setLabel(with: testDateTitle, using: .blackTitleText)
        symptomsToggleLabel.setLabel(with: symptomsToggleText, using: .blackTitleText)
        symptomsDateLabel.setLabel(with: symptomsDateTitle, using: .blackTitleText)
        nextButton.isEnabled = false
        nextButton.setButton(with: nextButtonText, and: .arrow)

        let enterDateHintText = NSLocalizedString(
            enterDateHint,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[enterDateHint] ?? "",
            comment: ""
        )

        let placeholderTextColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.00)
        testDateTextField.attributedPlaceholder = NSAttributedString(
            string: enterDateHintText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
        )
        symptomsDateTextField.attributedPlaceholder = NSAttributedString(
            string: enterDateHintText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
        )

        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return
        }

        testDateTextField.datePicker(
            target: self,
            doneAction: #selector(setTestDateAction),
            cancelAction: #selector(cancelAction),
            minimumDate: previousMonth,
            maximumDate: Date()
        )

        symptomsSwitch.addTarget(self, action: #selector(symptomsSwitchChanged), for: .valueChanged)

        symptomsDateTextField.datePicker(
            target: self,
            doneAction: #selector(setSymptomDateAction),
            cancelAction: #selector(cancelAction),
            minimumDate: previousMonth,
            maximumDate: Date()
        )
    }

    private func updateNextButton() {
        if testDateTextField.isNotEmpty() &&
            (!symptomsSwitch.isOn || symptomsDateTextField.isNotEmpty()) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
        }
    }

    @objc
    func cancelAction() {
        testDateTextField.resignFirstResponder()
        symptomsDateTextField.resignFirstResponder()
    }

    @objc
    func setTestDateAction() {
        if let datePickerView = testDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            testDateTextField.text = dateString
            testDateTextField.resignFirstResponder()
            updateNextButton()
        }
    }

    @objc
    func setSymptomDateAction() {
        if let datePickerView = symptomsDateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            symptomsDateTextField.text = dateString
            symptomsDateTextField.resignFirstResponder()
            updateNextButton()
        }
    }

    @objc
    func symptomsSwitchChanged() {
        symptomsDateLabel.isHidden = !symptomsSwitch.isOn
        symptomsDateTextField.isHidden = !symptomsSwitch.isOn
        updateNextButton()
    }

    @IBAction private func nextButtonTapped(_ sender: Any) {
        if contactTracerFlow {
            performSegue(withIdentifier: "ctFlowStep1Segue", sender: self)
        } else {
            performSegue(withIdentifier: "mhrFlowStep2Segue", sender: self)
        }
    }
}

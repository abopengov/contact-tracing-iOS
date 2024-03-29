import UIKit

extension UITextField {
    func datePicker<T>(
        target: T,
        doneAction: Selector,
        cancelAction: Selector,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil,
        mode: UIDatePicker.Mode = .date,
        minuteInterval: Int = 1
    ) {
        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction

                case .done:
                    return doneAction

                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(
                barButtonSystemItem: style,
                target: buttonTarget,
                action: action
            )

            return barButtonItem
        }

        let datePicker = UIDatePicker(
            frame: CGRect(
                x: 0,
                y: 0,
                width: screenWidth,
                height: 216
            )
        )
        datePicker.datePickerMode = mode
        datePicker.minuteInterval = minuteInterval
        if let minimumDate = minimumDate {
            datePicker.minimumDate = minimumDate
        }
        if let maximumDate = maximumDate {
            datePicker.maximumDate = maximumDate
        }
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }

        self.inputView = datePicker

        let toolBar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: screenWidth,
                height: 44
            )
        )

        toolBar.setItems(
            [
                buttonItem(withSystemItemStyle: .cancel),
                buttonItem(withSystemItemStyle: .flexibleSpace),
                buttonItem(withSystemItemStyle: .done)
            ],
            animated: true
        )
        self.inputAccessoryView = toolBar
    }

    func getDate() -> Date? {
        guard let datePicker = inputView as? UIDatePicker else {
            return nil
        }

        return datePicker.date
    }

    func isNotEmpty() -> Bool {
        guard let text = self.text else {
            return false
        }

        return !text.isEmpty
    }

    func setTime(time: Date?) {
        self.text = time?.getHourMinuteString() ?? ""

        if let datePicker = inputView as? UIDatePicker, let time = time {
            datePicker.date = time
        }
    }
}

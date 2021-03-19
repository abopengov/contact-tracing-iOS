import UIKit

class BlueToothViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generateHowItWorksViews(in: contentView)
    }
}

// MARK: - Button action
extension BlueToothViewController {
    override func buttonAction(_ sender: UIButton) {
        BluetoothStateManager.shared.requestBluetoothPermissions()
        BlueTraceLocalNotifications.shared.checkAuthorization { _ in
            DispatchQueue.main.async {
                self.navigator.navigate(from: self.identifier)
            }
        }
    }
}

// MARK: 
extension BlueToothViewController {
    private func generateHowItWorksViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        let layoutView = UIView()
        contentView.addSubview(layoutView)
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        layoutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        layoutView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let headerImageView = UIImageView()
        layoutView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 20).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor, constant: -20).isActive = true
        headerImageView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: 20).isActive = true

        headerImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true

        headerImageView.image = UIImage(named: "NotificationIllustration")

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        layoutView.addSubview(scrollView)

        let scrollViewContainer = UIStackView()

        scrollViewContainer.axis = .vertical
        scrollViewContainer.spacing = 10

        scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(scrollViewContainer)
        generateContent(in: scrollViewContainer)

        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func generateContent(in parentView: UIStackView) {
        let newView = UIView()
        parentView.addArrangedSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false

        let subHeaderMessageLabel = UILabel()
        newView.addSubview(subHeaderMessageLabel)
        subHeaderMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeaderMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 35).isActive = true
        subHeaderMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -35).isActive = true
        subHeaderMessageLabel.topAnchor.constraint(equalTo: newView.topAnchor, constant: 50).isActive = true

        subHeaderMessageLabel.setLabel(
            with: bluetoothMessageStep,
            using: .stepText
        )

        let headerMessageLabel1 = UILabel()
        newView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 35).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -35).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: subHeaderMessageLabel.bottomAnchor, constant: 5).isActive = true

        headerMessageLabel1.setLabel(
            with: bluetoothMessageHeader,
            using: .h2
        )

        let detailMessageLabel1 = UILabel()
        newView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 20).isActive = true

        detailMessageLabel1.setLabel(
            with: bluetoothMessageDetail,
            using: .body
        )

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            newView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString,
                using: .body
            )

            newView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            newView.bottomAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 20).isActive = true
        }
    }
}

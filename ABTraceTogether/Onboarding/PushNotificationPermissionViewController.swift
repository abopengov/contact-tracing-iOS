import UIKit

class PushNotificationPermissionViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generate(in: contentView)
        BlueTraceLocalNotifications.shared.checkAuthorization { _ in }
    }
}

// MARK: - Button action
extension PushNotificationPermissionViewController {
    override func buttonAction(_ sender: UIButton) {
        self.navigator.navigate(from: self.identifier)
    }
}

// MARK: 
extension PushNotificationPermissionViewController {
    private func generate(in contentView: UIView) {
        clearSubViews(from: contentView)
        generateContent(in: contentView)
    }

    private func generateContent(in parentView: UIView) {
        let headerImageView = UIImageView()
        parentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        headerImageView.image = UIImage(named: "NotificationStep")
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        let headerLabel = UILabel()
        parentView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.setLabel(with: onboardingNotificationsTitle, using: .h2)
        headerLabel.textAlignment = .left
        headerLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 64).isActive = true

        let descriptionView = UIView()
        parentView.addSubview(descriptionView)
        descriptionView.backgroundColor = Colors.LightGrey
        descriptionView.cornerRadius = 6
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        descriptionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true

        
        let descriptionLabel = UILabel()
        descriptionView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.setLabel(with: onboardingNotificationsDescription, using: .grayDescriptionText)
        descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 12).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -12).isActive = true
        
        let spacerView = UIView()
        parentView.addSubview(spacerView)
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        spacerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        spacerView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20).isActive = true
        
        parentView.bottomAnchor.constraint(equalTo: spacerView.bottomAnchor, constant: 20).isActive = true
    }
}

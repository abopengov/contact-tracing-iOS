import UIKit

class RegistrationSuccessfulViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        generateRegistrationSuccessfulViews(in: contentView)
    }
}

// MARK: 
extension RegistrationSuccessfulViewController {
    override func buttonAction(_ sender: UIButton) {
        navigator.onboardingCompleted = true
        navigator.successCompleted = true
        navigator.storedAppVersion = UIApplication.appVersion
        navigator.navigate(from: identifier)

        HeraldManager.shared.start()
    }

    override func createButton(in parentView: UIView) {
        let bottomButton = UIButton()
        parentView.addSubview(bottomButton)

        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        bottomButton.setButton(with: registrationSuccessfulFinishButtonText, and: .arrow)
        bottomButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

// MARK: 
extension RegistrationSuccessfulViewController {
    private func generateRegistrationSuccessfulViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        generateContent(in: contentView)
    }

    private func generateContent(in parentView: UIView) {
        let headerMessageLabel1 = UILabel()
        parentView.addSubview(headerMessageLabel1)
        headerMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 35).isActive = true
        headerMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -35).isActive = true
        headerMessageLabel1.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        headerMessageLabel1.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        headerMessageLabel1.setLabel(
            with: registrationSuccessfulHeader,
            using: .h2
        )

        let detailMessageLabel1 = UILabel()
        parentView.addSubview(detailMessageLabel1)
        detailMessageLabel1.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel1.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel1.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel1.topAnchor.constraint(equalTo: headerMessageLabel1.bottomAnchor, constant: 10).isActive = true
        detailMessageLabel1.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        detailMessageLabel1.setLabel(
            with: registrationSuccessfulDetail,
            using: .blackDescriptionCenteredText
        )

        let headerImageView = UIImageView()
        parentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: detailMessageLabel1.bottomAnchor, constant: 60).isActive = true
        headerImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        headerImageView.image = UIImage(named: "RegistrationSuccessfulIllustration")
        headerImageView.contentMode = .scaleAspectFill

        parentView.bottomAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 60).isActive = true
        }
    }

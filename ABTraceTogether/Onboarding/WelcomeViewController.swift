//import IBMMobileFirstPlatformFoundation
import UIKit

class WelcomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        generateWelcomeScreenViews(in: contentView)
    }
}

// MARK: 
extension WelcomeViewController {
    override func createButton(in parentView: UIView) {
        let bottomButton = UIButton()
        parentView.addSubview(bottomButton)

        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        bottomButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        bottomButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -30).isActive = true
        bottomButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        bottomButton.setButton(
            with: welcomeScreenButton,
            and: .arrow
        )
        bottomButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

// MARK: 
extension WelcomeViewController {
    private func generateWelcomeScreenViews(in contentView: UIView) {
        clearSubViews(from: contentView)

        let headerImageView = UIImageView()
        contentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        headerImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        headerImageView.image = UIImage(named: "Landing Illustration")
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        let headerMessageLabel = UILabel()
        contentView.addSubview(headerMessageLabel)
        headerMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35).isActive = true
        headerMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35).isActive = true
        headerMessageLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor).isActive = true

        headerMessageLabel.setLabel(
            with: welcomeScreenHeader ,
            using: .h2
        )

        let detailMessageLabel = UILabel()
        contentView.addSubview(detailMessageLabel)
        detailMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel.topAnchor.constraint(equalTo: headerMessageLabel.bottomAnchor, constant: 20).isActive = true

        detailMessageLabel.setLabel(
            with: welcomeScreenSubHeader,
            using: .body
        )

        let topBufferView = UIView()
        contentView.addSubview(topBufferView)
        topBufferView.translatesAutoresizingMaskIntoConstraints = false
        topBufferView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        topBufferView.setContentHuggingPriority(.defaultLow, for: .vertical)
        topBufferView.topAnchor.constraint(equalTo: detailMessageLabel.bottomAnchor).isActive = true

        let logoView = UIImageView()
        contentView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.topAnchor.constraint(equalTo: topBufferView.bottomAnchor, constant: 20).isActive = true
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        logoView.image = UIImage(named: "government-of-alberta-logo-vector 1")
        let logoMessageLabel = UILabel()
        contentView.addSubview(logoMessageLabel)
        logoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        logoMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        logoMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        logoMessageLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 5).isActive = true

        logoMessageLabel.setLabel(
            with: generalLogoMessageString,
            using: .eyebrowText
        )

        let bottomBufferView = UIView()
        contentView.addSubview(bottomBufferView)
        bottomBufferView.translatesAutoresizingMaskIntoConstraints = false
        bottomBufferView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        bottomBufferView.setContentHuggingPriority(.defaultLow, for: .vertical)
        bottomBufferView.topAnchor.constraint(equalTo: logoMessageLabel.bottomAnchor).isActive = true
        bottomBufferView.heightAnchor.constraint(equalTo: topBufferView.heightAnchor).isActive = true

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            contentView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: bottomBufferView.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString,
                using: .body
            )

            contentView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            contentView.bottomAnchor.constraint(equalTo: bottomBufferView.bottomAnchor, constant: 20).isActive = true
        }
    }
}

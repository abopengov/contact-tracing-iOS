import IBMMobileFirstPlatformFoundation
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

        let layoutView = UIView()
        contentView.addSubview(layoutView)
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        layoutView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        layoutView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        layoutView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -40).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        let headerImageView = UIImageView()
        layoutView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
        headerImageView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 20).isActive = true
        headerImageView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor, constant: -20).isActive = true
        headerImageView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: 20).isActive = true

        headerImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true

        headerImageView.image = UIImage(named: "Landing Illustration")
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
        scrollView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -30).isActive = true
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

        let headerMessageLabel = UILabel()
        newView.addSubview(headerMessageLabel)
        headerMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        headerMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 35).isActive = true
        headerMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -35).isActive = true
        headerMessageLabel.topAnchor.constraint(equalTo: newView.topAnchor, constant: 20).isActive = true

        headerMessageLabel.setLabel(
            with: welcomeScreenHeader ,
            using: .h2
        )

        let detailMessageLabel = UILabel()
        newView.addSubview(detailMessageLabel)
        detailMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        detailMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        detailMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        detailMessageLabel.topAnchor.constraint(equalTo: headerMessageLabel.bottomAnchor, constant: 20).isActive = true

        detailMessageLabel.setLabel(
            with: welcomeScreenSubHeader,
            using: .body
        )

        let logoView = UIImageView()
        newView.addSubview(logoView)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.topAnchor.constraint(equalTo: detailMessageLabel.bottomAnchor, constant: 20).isActive = true
        logoView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        logoView.image = UIImage(named: "vector-1")
        let logoMessageLabel = UILabel()
        newView.addSubview(logoMessageLabel)
        logoMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        logoMessageLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        logoMessageLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
        logoMessageLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 5).isActive = true

        logoMessageLabel.setLabel(
            with: generalLogoMessageString,
            using: .eyebrowText
        )

        if let versionLabelString = versionLabelString {
            let versionLabel = UILabel()
            newView.addSubview(versionLabel)
            versionLabel.translatesAutoresizingMaskIntoConstraints = false
            versionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
            versionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20).isActive = true
            versionLabel.topAnchor.constraint(equalTo: logoMessageLabel.bottomAnchor, constant: 20).isActive = true

            versionLabel.setLabel(
                with: versionLabelString ,
                using: .body
            )

            newView.bottomAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
        } else {
            newView.bottomAnchor.constraint(equalTo: logoMessageLabel.bottomAnchor, constant: 20).isActive = true
        }
    }
}

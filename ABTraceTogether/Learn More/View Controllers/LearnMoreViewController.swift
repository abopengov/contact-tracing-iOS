import UIKit

class LearnMoreViewController: UIViewController {
    @IBOutlet private var learnMoreTitleLabel: UILabel!
    @IBOutlet private var whatsNewLabel: UILabel!
    @IBOutlet private var whatsNewBadge: UIImageView!
    @IBOutlet private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true

        let appBasicsRow = createRow(imageName: "AppBasicsLight", text: appBasicsTitle, segue: "AppBasicsSegue")
        stackView.addArrangedSubview(appBasicsRow)

        let infoExchangedRow = createRow(imageName: "InfoExchangedLight", text: infoExchangedTitle, segue: "InfoExchangedSegue")
        stackView.addArrangedSubview(infoExchangedRow)

        let permissionsRow = createRow(imageName: "LocationLight", text: permissionsTitle, segue: "PermissionsSegue")
        stackView.addArrangedSubview(permissionsRow)

        let testingPositiveRow = createRow(imageName: "PositiveLight", text: testingPositiveTitle, segue: "TestingPositiveSegue")
        stackView.addArrangedSubview(testingPositiveRow)

        let potentialExposureRow = createRow(imageName: "PotentialExposuresLight", text: potentialExposuresTitle, segue: "PotentialExposuresSegue")
        stackView.addArrangedSubview(potentialExposureRow)

        let batteryConsumptionRow = createRow(imageName: "LightningBoltLight", text: batteryConsumptionTitle, segue: "BatteryConsumptionSegue")
        stackView.addArrangedSubview(batteryConsumptionRow)

        let faqRow = createRow(imageName: "FaqLight", text: faqTitle, gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(self.handleOpenFaq(_:))))
        stackView.addArrangedSubview(faqRow)

        learnMoreTitleLabel.setLabel(with: learnMoreTitle, using: .blackTitleText)

        whatsNewLabel.setLabel(with: whatsNewTitle, using: .blueLinkText)
        whatsNewLabel.underline()
        whatsNewLabel.addGestureRecognizer(RowGestureRecognizer(target: self, action: #selector(self.handleTap(_:)), segue: "WhatsNewSegue"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        whatsNewBadge.isHidden = AppData.userHasSeenWhatsNew
    }

    @objc
    private func handleTap(_ sender: Any) {
        if let gesture = sender as? RowGestureRecognizer {
            performSegue(withIdentifier: gesture.segue, sender: self)
        }
    }

    @objc
    private func handleOpenFaq(_ sender: Any) {
        if let url = URL(string: privacyFaqLink) {
            UIApplication.shared.open(url)
        }
    }

    private func createRow(imageName: String, text: String, gestureRecognizer: UITapGestureRecognizer) -> LearnMoreRowView {
        let row = Bundle.main.loadNibNamed("LearnMoreRowView", owner: self)?.first as! LearnMoreRowView
        row.image = UIImage(named: imageName)
        row.text = text
        row.addGestureRecognizer(gestureRecognizer)
        return row
    }

    private func createRow(imageName: String, text: String, segue: String) -> LearnMoreRowView {
        return createRow(imageName: imageName, text: text, gestureRecognizer: RowGestureRecognizer(target: self, action: #selector(self.handleTap(_:)), segue: segue))
    }
}

private class RowGestureRecognizer: UITapGestureRecognizer {
    let segue: String
    init(target: AnyObject, action: Selector, segue: String) {
        self.segue = segue
        super.init(target: target, action: action)
    }
}

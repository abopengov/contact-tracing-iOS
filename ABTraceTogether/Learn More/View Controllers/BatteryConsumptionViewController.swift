import UIKit

class BatteryConsumptionViewController: UIViewController {
    @IBOutlet private var cardContainer: UIView!
    @IBOutlet private var batteryConsumptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        batteryConsumptionLabel.setLabel(with: batteryConsumptionTitle, using: .blackTitleText)
        let learnMoreCardView: LearnMoreCardView = Bundle.main.loadNibNamed("LearnMoreCardView", owner: self, options: nil)?.first as! LearnMoreCardView
        cardContainer.addSubview(learnMoreCardView)
        learnMoreCardView.image = UIImage(named: "BatteryConsumptionCard")
        learnMoreCardView.text = batteryConsumptionDetails

        learnMoreCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            learnMoreCardView.topAnchor.constraint(equalTo: self.cardContainer.topAnchor),
            learnMoreCardView.bottomAnchor.constraint(equalTo: self.cardContainer.bottomAnchor),
            learnMoreCardView.leadingAnchor.constraint(equalTo: self.cardContainer.leadingAnchor),
            learnMoreCardView.trailingAnchor.constraint(equalTo: self.cardContainer.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
}

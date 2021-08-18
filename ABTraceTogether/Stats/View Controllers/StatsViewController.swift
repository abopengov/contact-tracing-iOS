import Foundation
import SafariServices
import UIKit

class StatsViewController: UIViewController {
    @IBOutlet private var statsTitleLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.clipsToBounds = true

        statsTitleLabel.setLabel(with: statsTitle, using: .blackTitleText)

        let covidCasesRow = createRow(imageName: "PositiveLight", text: statsCovidCases, segue: "StatsCovidCasesSegue")
        stackView.addArrangedSubview(covidCasesRow)

        let vaccinationsRow = createRow(imageName: "VaccineLight", text: statsVaccinations, segue: "StatsVaccinationsSegue")
        stackView.addArrangedSubview(vaccinationsRow)

        let mapRow = createRow(imageName: "WorldLight", text: statsMap, segue: "StatsMapSegue")
        stackView.addArrangedSubview(mapRow)

        let dashboardRow = createRow(imageName: "TakeMeIconLight", text: statsDashboard, gestureRecognizer: UITapGestureRecognizer(target: self, action: #selector(self.goToDashboardTapped(_:))))
        stackView.addArrangedSubview(dashboardRow)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @objc
    private func handleTap(_ sender: Any) {
        if let gesture = sender as? RowGestureRecognizer {
            performSegue(withIdentifier: gesture.segue, sender: self)
        }
    }

    @objc
    private func goToDashboardTapped(_ sender: Any) {
        if let url = URL(string: statisticsLink) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
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
        createRow(imageName: imageName, text: text, gestureRecognizer: RowGestureRecognizer(target: self, action: #selector(self.handleTap(_:)), segue: segue))
    }
}

private class RowGestureRecognizer: UITapGestureRecognizer {
    let segue: String
    init(target: AnyObject, action: Selector, segue: String) {
        self.segue = segue
        super.init(target: target, action: action)
    }
}

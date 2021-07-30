import Foundation
import SafariServices
import UIKit

enum HomeStatsColorStyle {
    case blue
    case purple
}

class HomeStatsView: UIView {
    weak var homeViewControllerDelegate: HomeViewControllerDelegate?

    @IBOutlet private var tableView: ContentSizedTableView!

    private var homeStats: [HomeStats] = []
    private var colorStyle: HomeStatsColorStyle = .blue

    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.register(UINib(nibName: "HomeStatsCell", bundle: nil), forCellReuseIdentifier: "HomeStatsCell")
        tableView.separatorStyle = .none
    }

    func setHomeStats(_ homeStats: [HomeStats]) {
        self.homeStats = homeStats
        self.tableView.reloadData()
    }

    func setColorStyle(_ colorStyle: HomeStatsColorStyle) {
        self.colorStyle = colorStyle
        self.tableView.reloadData()
    }

    private func gotoStatsTab() {
        homeViewControllerDelegate?.switchTab(.stats)
    }

    private func gotoCovidCases() {
        homeViewControllerDelegate?.switchTab(.stats, segueName: "StatsCovidCasesSegue")
    }

    private func gotoVaccinations() {
        homeViewControllerDelegate?.switchTab(.stats, segueName: "StatsVaccinationsSegue")
    }

    private func gotoMaps() {
        homeViewControllerDelegate?.switchTab(.stats, segueName: "StatsMapSegue")
    }

    private func goToDashboard() {
        if let url = URL(string: statisticsLink) {
            let vc = SFSafariViewController(url: url)
            homeViewControllerDelegate?.presentViewController(vc)
        }
    }
}

extension HomeStatsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.homeStats.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeStatsCell = tableView.dequeueReusableCell(withIdentifier: "HomeStatsCell", for: indexPath) as! HomeStatsCell
        let homeStat = homeStats[indexPath.row]

        homeStatsCell.titleLabel.setLabel(with: homeStat.title ?? "", using: .blueText, localize: false)
        if let valueText = homeStat.value {
            homeStatsCell.valueLabel.setLabel(with: valueText, using: .blueText, localize: false)
            homeStatsCell.valueLabel.isHidden = false
        } else {
            homeStatsCell.valueLabel.isHidden = true
        }

        switch (colorStyle) {
        case .blue:
            homeStatsCell.cellView.borderColor = Colors.ABBlue
            homeStatsCell.titleLabel.textColor = Colors.ABBlue
            homeStatsCell.valueLabel.textColor = Colors.ABBlue

        case .purple:
            homeStatsCell.cellView.borderColor = Colors.ABPurple
            homeStatsCell.titleLabel.textColor = Colors.ABPurple
            homeStatsCell.valueLabel.textColor = Colors.ABPurple
        }

        homeStatsCell.selectionStyle = .none

        return homeStatsCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeStat = homeStats[indexPath.row]

        switch (homeStat.type) {
        case .CASES:
            gotoCovidCases()

        case .VACCINATIONS:
            gotoVaccinations()

        case .MAP:
            gotoMaps()

        case .DASHBOARD:
            goToDashboard()

        default:
            gotoStatsTab()
        }
    }
}

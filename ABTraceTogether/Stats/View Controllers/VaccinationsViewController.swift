import SafariServices
import UIKit

class VaccinationsViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var lastUpdatedLabel: UILabel!
    @IBOutlet private var newVaccinationsLabel: UILabel!
    @IBOutlet private var newVaccinationsCountLabel: UILabel!
    @IBOutlet private var newVaccinationsTrendImageView: UIImageView!
    @IBOutlet private var totalVaccinationsLabel: UILabel!
    @IBOutlet private var totalVaccinationsCountLabel: UILabel!
    @IBOutlet private var totalFullVaccinationsLabel: UILabel!
    @IBOutlet private var totalFullVaccinationsCountLabel: UILabel!
    @IBOutlet private var vaccinesChartView: StatsChartView!
    @IBOutlet private var goToDashboardButton: UIButton!

    private var statsRepository: StatsRepository?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.setLabel(with: statsVaccinations, using: .blackTitleText)

        newVaccinationsLabel.setLabel(with: statsVaccinesGiven, using: .blackDescriptionMediumText)
        totalVaccinationsLabel.setLabel(with: statsVaccinesAdministered, using: .grayDescriptionMediumText)
        totalFullVaccinationsLabel.setLabel(with: statsFullyVaccinated, using: .grayDescriptionMediumText)
        lastUpdatedLabel.setLabel(with: "", using: .grayMediumText, localize: false)

        newVaccinationsCountLabel.setLabel(with: "-", using: .blueDescriptionMediumText)
        newVaccinationsTrendImageView.isHidden = true

        totalVaccinationsCountLabel.setLabel(with: "-", using: .grayDescriptionMediumText)
        totalFullVaccinationsCountLabel.setLabel(with: "-", using: .grayDescriptionMediumText)

        goToDashboardButton.setButton(with: statsGotoDashboard, and: .secondaryClickout, buttonStyle: .settings)

        vaccinesChartView.title = statsDosesOverTime

        statsRepository = StatsRepository()
        statsRepository?.getDailyStats { [weak self] dailyStats in
            if let dailyStats = dailyStats,
                let latestStats = dailyStats.last,
                let secondLatestStats = dailyStats.secondLast {
                self?.updateDailyStats(latestStats, secondLastStats: secondLatestStats)
                self?.updateCharts(dailyStats)
            } else {
                self?.lastUpdatedLabel.setLabel(with: errorCannotFetchData, using: .errorMediumText)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    private func updateDailyStats(_ latestStats: DailyStats, secondLastStats: DailyStats) {
        self.lastUpdatedLabel.setLabel(with: self.formatAsOfDate(latestStats.date), using: .grayMediumText, localize: false)
        self.newVaccinationsCountLabel.setLabel(with: StatsFormatter.formatWithCommas(latestStats.vaccineDosesGivenToday), using: .blueDescriptionMediumText)

        let trend = Trend.getTrend(previous: secondLastStats.vaccineDosesGivenToday, current: latestStats.vaccineDosesGivenToday)

        switch trend {
        case .up, .down:
            newVaccinationsTrendImageView.isHidden = false
            newVaccinationsTrendImageView.image = trend.image

        default:
            newVaccinationsTrendImageView.isHidden = true
        }

        self.totalVaccinationsCountLabel.setLabel(with: StatsFormatter.formatWithCommas(latestStats.cumulativeVaccineDoses), using: .grayDescriptionMediumText)
        self.totalFullVaccinationsCountLabel.setLabel(with: StatsFormatter.formatWithCommas(latestStats.peopleFullyVaccinated), using: .grayDescriptionMediumText)
    }

    private func updateCharts(_ stats: [DailyStats]) {
        self.vaccinesChartView.setChartData(stats.map { stat in stat.cumulativeVaccineDoses })
    }

    @IBAction private func goToDashboardTapped(_ sender: Any) {
        if let url = URL(string: statisticsLink) {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }

    private func formatAsOfDate(_ date: Date?) -> String {
        lastUpdated.localize() + " " + (date?.getDayMonthYearString() ?? "-")
    }
}

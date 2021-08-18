import SafariServices
import UIKit

class CovidCasesViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var lastUpdatedLabel: UILabel!
    @IBOutlet private var newCasesLabel: UILabel!
    @IBOutlet private var newCasesCountLabel: UILabel!
    @IBOutlet private var newCasesTrendImageView: UIImageView!
    @IBOutlet private var newVariantCasesLabel: UILabel!
    @IBOutlet private var newVariantCasesCountLabel: UILabel!
    @IBOutlet private var newVariantCasesTrendImageView: UIImageView!
    @IBOutlet private var zoneCasesLabel: UILabel!
    @IBOutlet private var zoneCasesTableView: UITableView!
    @IBOutlet private var zoneCasesTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var activeCasesChartView: StatsChartView!
    @IBOutlet private var goToDashboardButton: UIButton!

    private var statsRepository: StatsRepository?
    private var zoneStats: [ZoneStats] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.setLabel(with: statsCovidCases, using: .blackTitleText)

        newCasesLabel.setLabel(with: statsNewCases, using: .blackDescriptionMediumText)
        newVariantCasesLabel.setLabel(with: statsNewVariantCases, using: .grayDescriptionMediumText)
        lastUpdatedLabel.setLabel(with: "", using: .grayMediumText, localize: false)

        newCasesCountLabel.setLabel(with: "-", using: .blueDescriptionMediumText)
        newVariantCasesCountLabel.setLabel(with: "-", using: .grayDescriptionMediumText)

        newCasesTrendImageView.isHidden = true
        newVariantCasesTrendImageView.isHidden = true

        zoneCasesLabel.setLabel(with: statsActiveCasesByZone, using: .blackTitleMediumText)
        zoneCasesTableView.separatorStyle = .none
        zoneCasesTableView.allowsSelection = false
        zoneCasesTableView.delegate = self
        zoneCasesTableView.dataSource = self

        activeCasesChartView.title = statsActiveCasesOverTime

        goToDashboardButton.setButton(with: statsGotoDashboard, and: .secondaryClickout, buttonStyle: .settings)

        statsRepository = StatsRepository()
        statsRepository?.getDailyStats { [weak self] dailyStats in
            if let dailyStats = dailyStats,
                let latestStats = dailyStats.last,
                let secondLastStats = dailyStats.secondLast {
                self?.updateTodaysStats(latestStats, secondLastStats: secondLastStats)

                self?.updateCharts(dailyStats)
            } else {
                self?.lastUpdatedLabel.setLabel(with: errorCannotFetchData, using: .errorMediumText)
            }
        }

        statsRepository?.getZoneStats { [weak self] zoneStats in
            if let zoneStats = zoneStats {
                self?.zoneStats = zoneStats
                self?.zoneCasesTableView.reloadData()
                self?.zoneCasesTableViewHeightConstraint.constant = self?.zoneCasesTableView.contentSize.height ?? 0
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    private func updateTodaysStats(_ latestStats: DailyStats, secondLastStats: DailyStats) {
        self.lastUpdatedLabel.setLabel(with: self.formatAsOfDate(latestStats.date), using: .grayMediumText, localize: false)
        self.newCasesCountLabel.setLabel(with: StatsFormatter.formatWithCommas(latestStats.casesReported), using: .blueDescriptionMediumText)
        self.newVariantCasesCountLabel.setLabel(with: StatsFormatter.formatWithCommas(latestStats.newVariantCases), using: .grayDescriptionMediumText)

        let newCasesTrend = Trend.getTrend(previous: secondLastStats.casesReported, current: latestStats.casesReported)

        switch newCasesTrend {
        case .up, .down:
            newCasesTrendImageView.isHidden = false
            newCasesTrendImageView.image = newCasesTrend.image

        default:
            newCasesTrendImageView.isHidden = true
        }

        let variantsTrend = Trend.getTrend(previous: secondLastStats.newVariantCases, current: latestStats.newVariantCases)

        switch variantsTrend {
        case .up, .down:
            newVariantCasesTrendImageView.isHidden = false
            newVariantCasesTrendImageView.image = variantsTrend.greyImage

        default:
            newVariantCasesTrendImageView.isHidden = true
        }
    }

    private func updateCharts(_ stats: [DailyStats]) {
        self.activeCasesChartView.setChartData(stats.map { stat in stat.activeCasesReported })
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

extension CovidCasesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.zoneStats.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let zoneStatsCell = tableView.dequeueReusableCell(withIdentifier: "ZoneStatsCell", for: indexPath) as! ZoneStatsCell
        let zone = zoneStats[indexPath.row]

        zoneStatsCell.zoneName.setLabel(with: zone.zone ?? "-", using: .grayDescriptionMediumText)
        zoneStatsCell.zoneCasesCount.setLabel(with: StatsFormatter.formatWithCommas(zone.activeCases), using: .blueDescriptionMediumText)

        if (indexPath.row == zoneStats.count - 1) {
            zoneStatsCell.divider.isHidden = true
        }

        return zoneStatsCell
    }
}

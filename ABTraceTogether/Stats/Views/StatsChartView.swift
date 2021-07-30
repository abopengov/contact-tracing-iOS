import Charts
import UIKit

class StatsChartView: UIView, NibLoadable {
    @IBOutlet private var label: UILabel!
    @IBOutlet private var barChartView: BarChartView!
    @IBOutlet private var lineChartView: LineChartView!
    @IBOutlet private var segmentedControl: UISegmentedControl!

    private let threeMonthsLabelFreqency = 15
    private let sixMonthsLabelFrequency = 30

    private var data: [Int?] = []

    var title: String {
        get {
            label?.text ?? ""
        }
        set {
            label.setLabel(with: newValue, using: .blackTitleMediumText)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        segmentedControl.setTitle(statsLast30Days.localize(), forSegmentAt: 0)
        segmentedControl.setTitle(statsLastThreeMonths.localize(), forSegmentAt: 1)
        segmentedControl.setTitle(statsLastSixMonths.localize(), forSegmentAt: 2)

        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = Colors.ABBlue
            segmentedControl.backgroundColor = UIColor.white
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.TextGrey], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        }
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        setupBarChart()
        setupLineChart()
    }

    @objc
    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        displayChartData()
    }

    func setChartData(_ values: [Int?]) {
        data = values
        displayChartData()
    }

    private func displayChartData() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            displayBarData()

        case 1:
            displayLineData(90, labelFreqency: threeMonthsLabelFreqency)

        default:
            displayLineData(180, labelFreqency: sixMonthsLabelFrequency)
        }
    }

    private func setupBarChart() {
        barChartView.chartDescription.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.enabled = false
        barChartView.legend.enabled = false
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.isMultipleTouchEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.leftAxis.axisMinimum = 0

        if let labelFont = UIFont(name: "HelveticaNeue", size: 12) {
            barChartView.leftAxis.labelFont = labelFont
            barChartView.leftAxis.labelTextColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.00)
        }

        barChartView.leftAxis.valueFormatter = AxisCommaFormater()
    }

    private func setupLineChart() {
        lineChartView.isVisible = false
        lineChartView.chartDescription.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.dragEnabled = false
        lineChartView.pinchZoomEnabled = false
        lineChartView.isMultipleTouchEnabled = false
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        lineChartView.maxVisibleCount = 200
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.extraTopOffset = 15
        lineChartView.extraRightOffset = 25
    }

    private func displayBarData() {
        barChartView.isVisible = true
        lineChartView.isVisible = false

        let yVals = data.suffix(30).enumerated().map { index, element in
            BarChartDataEntry(x: Double(index), y: Double(element ?? 0))
        }

        let set1 = BarChartDataSet(entries: yVals, label: "")
        set1.colors = [NSUIColor(red: 0.09, green: 0.41, blue: 0.69, alpha: 1.00)]
        set1.drawValuesEnabled = false

        let data = BarChartData(dataSet: set1)
        barChartView.data = data
        barChartView.notifyDataSetChanged()
    }

    func displayLineData(_ dataLimit: Int, labelFreqency: Int) {
        barChartView.isVisible = false
        lineChartView.isVisible = true

        var chartDataCounter = 0
        let dataSets: [LineChartDataSet] = data.suffix(dataLimit)
            .map { stat -> ChartDataElement in
                let data = ChartDataElement(x: Double(chartDataCounter), y: stat)
                chartDataCounter += 1
                return data
            }
            .split { $0.y == nil }
            .map { dataEntriesList -> [ChartDataEntry] in
                let chartDataEntryList = dataEntriesList.map { element -> ChartDataEntry in
                    return ChartDataEntry(x: Double(element.x), y: Double(element.y ?? 0))
                }
                return chartDataEntryList
            }
            .map { entries -> LineChartDataSet in
                let dataSet = ABLineChartDataSet(entries: entries, label: "")
                dataSet.colors = [NSUIColor(cgColor: Colors.ABBlue.cgColor)]
                dataSet.drawValuesEnabled = true
                dataSet.lineWidth = 3
                dataSet.fillColor = NSUIColor(cgColor: Colors.BorderBlue.cgColor)
                dataSet.drawFilledEnabled = true
                dataSet.drawCirclesEnabled = false
                dataSet.circleRadius = 20
                if let valueFont = UIFont(name: "HelveticaNeue-Medium", size: 11) {
                    dataSet.valueFont = valueFont
                }
                dataSet.valueTextColor = NSUIColor(cgColor: Colors.ABBlue.cgColor)
                dataSet.valueFormatter = CustomLineDataFormatter(labelFrequency: labelFreqency)
                return dataSet
            }

        let data = LineChartData(dataSets: dataSets)
        lineChartView.data = data
        lineChartView.notifyDataSetChanged()
    }
}

final class AxisCommaFormater: NSObject, AxisValueFormatter {
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        Int(value).withCommas()
    }
}

final class CustomLineDataFormatter: NSObject, ValueFormatter {
    let labelFrequency: Int

    init(labelFrequency: Int) {
        self.labelFrequency = labelFrequency
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        Int(entry.x + 1).isMultiple(of: labelFrequency) ? Int(value).withCommas() : ""
    }
}

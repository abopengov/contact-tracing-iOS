import SwiftUI
import WidgetKit

struct NewCasesWidgetEntryView: View {
    var entry: DailyStatsEntry

    var body: some View {
        SingleStatView(
            stat: Stat(
                name: "Cases today",
                value: entry.currentStats?.casesReported,
                previousValue: entry.previousStats?.casesReported
            )
        )
    }
}

struct NewCasesWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "NewCasesWidget",
            provider: DailyStatsProvider()
        ) { entry in
            NewCasesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cases today")
        .description("Shows New Cases Today in Alberta")
        .supportedFamilies([.systemSmall])
    }
}

struct NewCasesWidget_Previews: PreviewProvider {
    static var previews: some View {
        let currentStats = DailyStats(
            date: Date(),
            casesReported: 1996,
            cumulativeCases: 196_910,
            newVariantCases: 123,
            vaccineDosesGivenToday: 17_490,
            cumulativeVaccineDoses: 1_620_032,
            activeCasesReported: 23_608,
            peopleFullyVaccinated: 200
        )

        let previousStats = DailyStats(
            date: Date(),
            casesReported: 1730,
            cumulativeCases: 194_914,
            newVariantCases: 124,
            vaccineDosesGivenToday: 25_082,
            cumulativeVaccineDoses: 1_602_542,
            activeCasesReported: 23_126,
            peopleFullyVaccinated: 200
        )

        NewCasesWidgetEntryView(entry: DailyStatsEntry(date: Date(), previousStats: previousStats, currentStats: currentStats))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

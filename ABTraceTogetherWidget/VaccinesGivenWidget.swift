import SwiftUI
import WidgetKit

struct VaccinesGivenEntryView: View {
    var entry: DailyStatsEntry

    var body: some View {
        SingleStatView(
            stat: Stat(
                name: "Vaccines today",
                value: entry.currentStats?.vaccineDosesGivenToday,
                previousValue: entry.previousStats?.vaccineDosesGivenToday
            )
        )
    }
}

struct VaccinesGivenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "VaccinesGivenWidget",
            provider: DailyStatsProvider()
        ) { entry in
            VaccinesGivenEntryView(entry: entry)
        }
        .configurationDisplayName("Vaccines today")
        .description("Shows Vaccines Given Today in Alberta")
        .supportedFamilies([.systemSmall])
    }
}

struct VaccinesGivenWidget_Previews: PreviewProvider {
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

        VaccinesGivenEntryView(entry: DailyStatsEntry(date: Date(), previousStats: previousStats, currentStats: currentStats))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

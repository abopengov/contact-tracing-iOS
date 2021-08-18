import SwiftUI
import WidgetKit

struct GradientLogoView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Image("PurpleBanner")
                .resizable()
            Image("Logo2")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 19)
                .padding(.leading, 16)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
    }
}

struct StatRow: View {
    var title: String
    var focused = true
    var previousValue: Int?
    var currentValue: Int?

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("HelveticaNeue", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color(Colors.DarkGrey))
                Spacer()
            TrendView(
                focused: focused,
                content: currentValue?.withCommas() ?? "-",
                trending: Trend.getTrend(
                    previous: previousValue,
                    current: currentValue
                )
            )
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
    }
}

struct DailyStatsView: View {
    var entry: DailyStatsEntry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemMedium:
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                GradientLogoView()
                Group {
                    StatRow(
                        title: "Cases today",
                        previousValue: entry.previousStats?.casesReported,
                        currentValue: entry.currentStats?.casesReported
                    )
                    Divider()
                    StatRow(
                        title: "Vaccines today",
                        previousValue: entry.previousStats?.vaccineDosesGivenToday,
                        currentValue: entry.currentStats?.vaccineDosesGivenToday
                    )
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }

        case .systemLarge:
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                GradientLogoView()
                Group {
                    StatRow(
                        title: "Cases today",
                        previousValue: entry.previousStats?.casesReported,
                        currentValue: entry.currentStats?.casesReported
                    )
                    Divider()
                    StatRow(
                        title: "Variant cases today",
                        focused: false,
                        previousValue: entry.previousStats?.newVariantCases,
                        currentValue: entry.currentStats?.newVariantCases
                    )
                    Divider()
                    StatRow(
                        title: "Vaccines today",
                        previousValue: entry.previousStats?.vaccineDosesGivenToday,
                        currentValue: entry.currentStats?.vaccineDosesGivenToday
                    )
                    Divider()
                    StatRow(
                        title: "Vaccines to-date",
                        focused: false,
                        currentValue: entry.currentStats?.cumulativeVaccineDoses
                    )
                    Divider()
                    StatRow(
                        title: "Fully vaccinated",
                        focused: false,
                        currentValue: entry.currentStats?.peopleFullyVaccinated
                    )
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }

        default:
            fatalError("Unsupported size")
        }
    }
}

struct DailyStatsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "DailyStatsWidget",
            provider: DailyStatsProvider()
        ) { entry in
            DailyStatsView(entry: entry)
        }
        .configurationDisplayName("Daily stats")
        .description("Shows Daily Stats for Alberta")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct DailyStatsWidget_Previews: PreviewProvider {
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

        Group {
            DailyStatsView(entry: DailyStatsEntry(date: Date(), previousStats: previousStats, currentStats: currentStats))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            DailyStatsView(entry: DailyStatsEntry(date: Date(), previousStats: previousStats, currentStats: currentStats))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

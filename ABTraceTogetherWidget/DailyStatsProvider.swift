import SwiftUI
import WidgetKit

struct DailyStatsEntry: TimelineEntry {
    var date: Date
    var previousStats: DailyStats?
    var currentStats: DailyStats?
}

struct DailyStatsProvider: TimelineProvider {
    let statsClient = MfpStatsClient()

    func getSnapshot(in context: Context, completion: @escaping (DailyStatsEntry) -> Void) {
        getDailyStatsEntry { entry in
            if let entry = entry {
                completion(entry)
            } else {
                completion(DailyStatsEntry(date: Date()))
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyStatsEntry>) -> Void) {
        getDailyStatsEntry { entry in
            var entries: [DailyStatsEntry] = []
            let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()

            if let entry = entry {
                entries.append(entry)
            }

            let timeline = Timeline(
                entries: entries,
                policy: .after(nextUpdateDate)
            )

            completion(timeline)
        }
    }

    func placeholder(in context: Context) -> DailyStatsEntry {
        DailyStatsEntry(date: Date())
    }

    private func getDailyStatsEntry(_ callback: @escaping (DailyStatsEntry?) -> Void) {
        statsClient.getDailyStats { dailyStats in
            if let previousDaily = dailyStats?.secondLast,
                let currentDaily = dailyStats?.last,
                let date = currentDaily.date {
                let entry = DailyStatsEntry(
                    date: date,
                    previousStats: previousDaily,
                    currentStats: currentDaily
                )
                callback(entry)
            } else {
                callback(nil)
            }
        }
    }
}

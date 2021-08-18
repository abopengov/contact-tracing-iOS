import SwiftUI
import WidgetKit

@main
struct ABTraceTogetherBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NewCasesWidget()
        VaccinesGivenWidget()
        DailyStatsWidget()
    }
}

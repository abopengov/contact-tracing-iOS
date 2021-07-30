import SwiftUI
import WidgetKit

struct TrendView: View {
    @Environment(\.widgetFamily) var family
    var focused = true
    var content: String
    var trending: Trend
    var body: some View {
        HStack {
            Text(content)
                .font(trendFont())
                .foregroundColor(focused ? Color(Colors.ABBlue) : Color(Colors.DarkGrey))

            if let image = trendImage() {
                image
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: trendHeight())
            }
        }
    }

    private func trendFont() -> Font {
        if family == .systemSmall {
            return Font.custom("HelveticaNeue-Bold", size: 25)
        } else {
            return Font.custom("HelveticaNeue-Medium", size: 16)
        }
    }

    private func trendHeight() -> CGFloat {
        family == .systemSmall ? 18 : 12
    }

    private func trendImage() -> Image? {
        if let image = focused ? trending.image : trending.greyImage {
            return Image(uiImage: image)
        } else {
            return nil
        }
    }
}

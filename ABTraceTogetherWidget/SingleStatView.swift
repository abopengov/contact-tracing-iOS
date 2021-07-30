import SwiftUI
import WidgetKit

struct LogoView: View {
    var body: some View {
        Image("Logo2")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(14)
            .background(Color(Colors.ABPurple))
    }
}

struct SingleStatView: View {
    var stat: Stat
    var body: some View {
        VStack(
            alignment: .center
        ) {
            LogoView()
            Spacer()
            TrendView(content: stat.value?.withCommas() ?? "-", trending: stat.trend())
            Text(stat.name)
                .font(.custom("HelveticaNeue-Medium", size: 17))
                .fontWeight(.medium)
                .foregroundColor(Color(Colors.DarkGrey))
            Spacer()
        }
    }
}

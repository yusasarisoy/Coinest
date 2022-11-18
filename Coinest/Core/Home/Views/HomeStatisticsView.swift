import SwiftUI

struct HomeStatisticsView: View {
  // MARK: - Properties
  @EnvironmentObject private var homeViewModel: HomeViewModel
  @Binding var showPortfolio: Bool

  // MARK: - View
  var body: some View {
    HStack {
      ForEach(homeViewModel.statistics) { statistic in
        StatisticView(statistic: statistic)
          .frame(width: CGFloat.oneThirdOfWidth)
      }
    }
    .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
  }
}

// MARK: - Preview
struct HomeStatisticsView_Previews: PreviewProvider {
  static var previews: some View {
    HomeStatisticsView(showPortfolio: .constant(false))
      .environmentObject(developer.homeViewModel)
  }
}

import SwiftUI

struct DetailLoadingView: View {
  // MARK: - Properties
  @Binding var coin: Coin?

  // MARK: - View
  var body: some View {
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}

struct DetailView: View {
  // MARK: - Properties
  @StateObject private var detailViewModel: DetailViewModel

  private let spacing: CGFloat = 30
  private let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  // MARK: - Initialization
  init(coin: Coin) {
    _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }

  // MARK: - View
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Spacer()
        overview
        additionalDetails
      }
      .padding()
    }
    .navigationTitle(detailViewModel.coin.name.orEmpty)
  }
}

private extension DetailView {
  var overview: some View {
    VStack {
      Text("overview")
        .font(.title2)
        .foregroundColor(Color.theme.accent)
        .frame(maxWidth: .infinity, alignment: .leading)
      Divider()

      LazyVGrid(
        columns: columns,
        alignment: .leading,
        spacing: spacing,
        pinnedViews: [],
        content: {
          ForEach(detailViewModel.overviewStatistics) { overview in
            StatisticView(statistic: overview)
          }
        }
      )
    }
  }

  var additionalDetails: some View {
    VStack {
      Text("additionalDetails")
        .font(.title2)
        .foregroundColor(Color.theme.accent)
        .frame(maxWidth: .infinity, alignment: .leading)
      Divider()

      LazyVGrid(
        columns: columns,
        alignment: .leading,
        spacing: spacing,
        pinnedViews: [],
        content: {
          ForEach(detailViewModel.additionalDetailsStatistics) { additionalDetail in
            StatisticView(statistic: additionalDetail)
          }
        }
      )
    }
  }
}

// MARK: - Preview
struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(coin: developer.coin)
    }
  }
}

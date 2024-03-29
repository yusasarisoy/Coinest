import SwiftUI

struct HomeView: View {
  // MARK: - Properties
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  @State private var showPortfolio = false
  @State private var showPortfolioView = false
  @State private var selectedCoin: Coin?
  @State private var showDetailView = false
  
  // MARK: - View
  var body: some View {
    NavigationStack {
      ZStack {
        Color.theme.background
          .ignoresSafeArea()
        VStack {
          homeHeader
          HomeStatisticsView(showPortfolio: $showPortfolio)
          Divider()
            .overlay(Color.theme.background)
          columnTitles
          if showPortfolio {
            portfolioListing
              .transition(.move(edge: .trailing))
          } else {
            cryptocurrenciesListing
              .transition(.move(edge: .leading))
          }
          SearchBarView(searchText: $homeViewModel.searchText)
        }
      }
      .navigationDestination(isPresented: $showDetailView) {
        DetailLoadingView(coin: $selectedCoin)
      }
    }
    .onAppear {
      homeViewModel.updateList()
    }
    .sheet(isPresented: $showPortfolioView) {
      PortfolioView()
        .environmentObject(homeViewModel)
    }
  }
}

// MARK: - Private Helpers
private extension HomeView {
  // MARK: - Views
  var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? IconNaming.shared.plus : IconNaming.shared.info)
        .onTapGesture {
          if showPortfolio {
            showPortfolioView.toggle()
          }
        }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      Spacer()
      Text(showPortfolio ? "portfolio" : "livePrices")
        .font(.headline.weight(.bold))
        .foregroundColor(Color.theme.accent)
      Spacer()
      CircleButtonView(iconName: IconNaming.shared.chevronRight)
        .rotationEffect(.init(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }
  
  var columnTitles: some View {
    HStack(spacing: .zero) {
      HStack {
        Text("coin")
          .padding(.leading, 25)
        Image(systemName: IconNaming.shared.chevronDown)
          .opacity([SortOption.rank, SortOption.rankReversed].contains(homeViewModel.sortOption) ? 1 : 0)
          .rotationEffect(.init(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          homeViewModel.sortOption = homeViewModel.sortOption == .rank
          ? .rankReversed
          : .rank
        }
      }
      Spacer()
      if showPortfolio {
        HStack {
          Text("holdings")
          Image(systemName: IconNaming.shared.chevronDown)
            .opacity([SortOption.holdings, SortOption.holdingsReversed].contains(homeViewModel.sortOption) ? 1 : 0)
            .rotationEffect(.init(degrees: homeViewModel.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
          withAnimation(.default) {
            homeViewModel.sortOption = homeViewModel.sortOption == .holdings
            ? .holdingsReversed
            : .holdings
          }
        }
      }
      HStack {
        Text("price")
          .frame(width: CGFloat.oneThirdOfWidth, alignment: .trailing)
        Image(systemName: IconNaming.shared.chevronDown)
          .opacity([SortOption.price, SortOption.priceReversed].contains(homeViewModel.sortOption) ? 1 : 0)
          .rotationEffect(.init(degrees: homeViewModel.sortOption == .price ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          homeViewModel.sortOption = homeViewModel.sortOption == .price
          ? .priceReversed
          : .price
        }
      }
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .padding(.horizontal)
  }
  
  var portfolioListing: some View {
    ScrollView {
      LazyVStack {
        ForEach(homeViewModel.portfolioCoins) { coin in
          CoinRowView(coin: coin, showHoldings: true)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
        }
      }
      .listStyle(.plain)
      .opacity(homeViewModel.portfolioCoins.isEmpty ? 0 : 1)
    }
  }
  
  var cryptocurrenciesListing: some View {
    NavigationView {
      List {
        ForEach(homeViewModel.coins, id: \.id) { coin in
          CoinRowView(coin: coin, showHoldings: false)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            .onTapGesture {
              navigateToDetail(basedOn: coin)
            }
        }
        if !homeViewModel.coins.isEmpty,
           homeViewModel.hasMoreCoins {
          ProgressView("loading")
            .padding()
            .frame(maxWidth: .infinity)
            .onAppear {
              homeViewModel.updateList()
            }
        }
      }
      .listStyle(.plain)
    }
    .navigationViewStyle(.stack)
  }
  
  // MARK: - Methods
  func navigateToDetail(basedOn coin: Coin) {
    selectedCoin = coin
    showDetailView.toggle()
  }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
    .environmentObject(HomeViewModel())
  }
}

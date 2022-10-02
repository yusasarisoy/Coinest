//
//  HomeView.swift
//  Coinest
//
//  Created by Yuşa on 22.09.2022.
//

import SwiftUI

struct HomeView: View {
  // MARK: - Properties
  @EnvironmentObject private var homeViewModel: HomeViewModel
  @State private var showPortfolio = false

  // MARK: - View
  var body: some View {
    ZStack {
      Color.theme.background
        .ignoresSafeArea()
      VStack {
        homeHeader
        HomeStatisticsView(showPortfolio: $showPortfolio)
        SearchBarView(searchText: $homeViewModel.searchText)
        columnTitles
        if showPortfolio {
          portfolioListing
            .transition(.move(edge: .trailing))
        } else {
          cryptocurrenciesListing
            .transition(.move(edge: .leading))
        }
        Spacer()
      }
    }
  }
}

// MARK: - Home Header View
private extension HomeView {
  var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? IconNaming.shared.plus : IconNaming.shared.info)
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      Spacer()
      Text(showPortfolio ? TitleNaming.shared.portfolio : TitleNaming.shared.livePrices)
        .font(.headline)
        .fontWeight(.light)
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
      Text("Coin")
        .padding(.leading, 25)
      Spacer()
      if showPortfolio {
        Text("Holdings")
      }
      Text("Price")
        .frame(width: CGFloat.oneThirdOfWidth, alignment: .trailing)
    }
    .font(.caption)
    .foregroundColor(Color.theme.secondaryText)
    .padding(.horizontal)
  }

  var portfolioListing: some View {
    List {
      ForEach(homeViewModel.coins) { coin in
        CoinRowView(coin: coin, showHoldings: true)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
    .opacity(homeViewModel.portfolioCoins.isEmpty ? 0 : 1)
  }

  var cryptocurrenciesListing: some View {
    List {
      ForEach(homeViewModel.coins) { coin in
        CoinRowView(coin: coin, showHoldings: false)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
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
    .environmentObject(developer.homeViewModel)
  }
}

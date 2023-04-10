import SwiftUI

struct PortfolioView: View {
  // MARK: - Properties
  @Environment(\.dismiss) private var dismiss

  @EnvironmentObject private var homeViewModel: HomeViewModel

  @State private var selectedCoin: Coin?
  @State private var quantityText = String.empty
  @State private var showCheckmark = false

  // MARK: - View
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: .zero) {
          SearchBarView(searchText: $homeViewModel.searchText)
          coinList
          if selectedCoin != nil {
            portfolioInputView
          }
        }
      }
      .navigationTitle("editPortfolio")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          leadingNavigationBarItems
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavigationBarItems
        }
      })
      .onChange(of: homeViewModel.searchText) { newValue in
        if newValue == .empty {
          removeSelectedCoin()
        }
      }
    }
  }
}

// MARK: - Portfolio Views
private extension PortfolioView {
  var coinList: some View {
    ScrollView(
      .horizontal,
      showsIndicators: false,
      content: {
        LazyHStack(spacing: 10) {
          ForEach(homeViewModel.searchText.isEmpty
                  ? homeViewModel.portfolioCoins
                  : homeViewModel.coins) { coin in
            CoinLogoView(coin: coin)
              .frame(width: 75)
              .padding(5)
              .onTapGesture {
                withAnimation(.easeIn) {
                  updateSelectedCoin(coin)
                }
              }
              .background(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(
                    selectedCoin?.id == coin.id ? Color.theme.secondaryText : .clear,
                    lineWidth: 1
                  )
              )
          }
        }
      }
    )
    .padding()
  }

  var portfolioInputView: some View {
    VStack(spacing: 20) {
      HStack {
        Text("\((selectedCoin?.symbol?.uppercased()).orEmpty) currentPrice")
        Spacer()
        Text((selectedCoin?.currentPrice?.asCurrencyWith2Decimals()).orEmpty)
      }
      Divider()
      HStack {
        Text("amount")
        Spacer()
        TextField("example", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("currentValue")
        Spacer()
        Text(currentCoinValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none, value: false)
    .padding(20)
    .font(.headline)
  }

  var leadingNavigationBarItems: some View {
    Button(action: {
      dismiss.callAsFunction()
    }, label: {
      Image(systemName: IconNaming.shared.xMark)
        .font(.headline)
    })
  }

  var trailingNavigationBarItems: some View {
    HStack(spacing: 10) {
      Image(systemName: IconNaming.shared.checkmark)
        .opacity(showCheckmark ? 1 : 0)
      Button {
        didTapSaveButton()
      } label: {
        Text("save")
      }
      .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)
    }
    .font(.headline)
  }
}

// MARK: - Private Helper Methods
private extension PortfolioView {
  func currentCoinValue() -> Double {
    guard let quantity = Double(quantityText) else { return .zero }
    return quantity * (selectedCoin?.currentPrice).orZero
  }

  func didTapSaveButton() {
    guard
      let coin = selectedCoin,
      let amount = Double(quantityText) else {
      return
    }

    homeViewModel.updatePortfolio(
      withCoin: coin,
      withAmount: amount
    )

    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }

    UIApplication.shared.endEditing()
    
    Task {
      try await Task.sleep(for: .seconds(2))
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
  }

  func updateSelectedCoin(_ coin: Coin) {
    selectedCoin = coin
    guard let portfolioCoin = homeViewModel.portfolioCoins.first(where: { $0.id == coin.id }),
          let amount = portfolioCoin.currentHoldings
    else {
      quantityText = .empty
      return
    }

    quantityText = amount.toString
  }

  func removeSelectedCoin() {
    selectedCoin = .none
    homeViewModel.searchText = .empty
  }
}

// MARK: - Preview
struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(developer.homeViewModel)
  }
}

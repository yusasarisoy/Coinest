//
//  PortfolioView.swift
//  Coinest
//
//  Created by Yuşa on 5.10.2022.
//

import SwiftUI

struct PortfolioView: View {
  // MARK: - Properties
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
      .navigationTitle("Edit Portfolio")
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavigationBarItems
        }
      })
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
          ForEach(homeViewModel.coins) { coin in
            CoinLogoView(coin: coin)
              .frame(width: 75)
              .padding(5)
              .onTapGesture {
                withAnimation(.easeIn) {
                  selectedCoin = coin
                }
              }
              .background(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(selectedCoin?.id == coin.id ? Color.theme.secondaryText : .clear, lineWidth: 2)
              )
          }
        }
        .padding(.vertical, 5)
      }
    )
  }

  var portfolioInputView: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \((selectedCoin?.symbol?.uppercased()).orEmpty): ")
        Spacer()
        Text((selectedCoin?.currentPrice?.asCurrencyWith2Decimals()).orEmpty)
      }
      Divider()
      HStack {
        Text("Amount in your portfolio:")
        Spacer()
        TextField("Ex: 1.5", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      Divider()
      HStack {
        Text("Current value:")
        Spacer()
        Text(currentCoinValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none, value: false)
    .padding(20)
    .font(.headline)
  }

  var trailingNavigationBarItems: some View {
    HStack(spacing: 10) {
      Image(systemName: IconNaming.shared.checkmark)
        .opacity(showCheckmark ? 1 : 0)
      Button {
        didTapSaveButton()
      } label: {
        Text("SAVE")
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
    // TODO: - Add to the portfolio.

    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoin()
    }

    UIApplication.shared.endEditing()
    
    Task {
      try await Task.sleep(withSeconds: 2)
      withAnimation(.easeOut) {
        showCheckmark = false
      }
    }
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

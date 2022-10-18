//
//  DetailView.swift
//  Coinest
//
//  Created by Yuşa on 17.10.2022.
//

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

  // MARK: - Initialization
  init(coin: Coin) {
    _detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }

  // MARK: - View
  var body: some View {
    ZStack {
      Text("Hello, World!")
    }
  }
}

// MARK: - Preview
struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: developer.coin)
  }
}

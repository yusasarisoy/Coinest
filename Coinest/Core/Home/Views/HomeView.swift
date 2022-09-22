//
//  HomeView.swift
//  Coinest
//
//  Created by Yuşa on 22.09.2022.
//

import SwiftUI

struct HomeView: View {
  // MARK: - Properties
  @State private var showPortfolio = false

  // MARK: - View
  var body: some View {
    ZStack {
      Color.theme.background
        .ignoresSafeArea()
      VStack {
        homeHeader
        Spacer()
      }
    }
  }
}

// MARK: - Home Header View
extension HomeView {
  private var homeHeader: some View {
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
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
  }
}

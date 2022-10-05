//
//  CoinestApp.swift
//  Coinest
//
//  Created by Yuşa on 9.07.2022.
//

import SwiftUI

@main
struct CoinestApp: App {
  // MARK: - Properties
  @StateObject var homeViewModel = HomeViewModel()

  init() {
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
  }

  // MARK: - Scene
  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true)
      }
      .environmentObject(homeViewModel)
    }
  }
}

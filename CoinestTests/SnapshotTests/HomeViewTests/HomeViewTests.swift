//
//  HomeViewTests.swift
//  CoinestTests
//
//  Created by Yuşa on 8.11.2022.
//

@testable import Coinest
import SnapshotTesting
import SwiftUI
import XCTest

final class HomeViewTests: XCTestCase {
  private let coin = DeveloperPreview.instance.coin
  private var viewController: UIViewController!

  override func setUpWithError() throws {
    try super.setUpWithError()
    let homeViewModel = HomeViewModel()
    let homeView = HomeView()
      .environmentObject(homeViewModel)
    viewController = UIHostingController(rootView: homeView)
  }

  override func tearDownWithError() throws {
    viewController = nil
    try super.tearDownWithError()
  }

  func testHomeViewOniPhone() throws {
    assertSnapshot(
      matching: viewController,
      as: .image(on: .iPhone13Mini)
    )
  }

  func testHomeViewOniPhonePortrait() throws {
    assertSnapshot(
      matching: viewController,
      as: .image(on: .iPhone13Mini(.portrait))
    )
  }

  func testHomeViewOniPhoneLandscape() throws {
    assertSnapshot(
      matching: viewController,
      as: .image(on: .iPhone13Mini(.landscape))
    )
  }
}

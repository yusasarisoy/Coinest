//
//  CoinRowViewTests.swift
//  CoinestTests
//
//  Created by Yuşa on 7.11.2022.
//

@testable import Coinest
import SnapshotTesting
import SwiftUI
import XCTest

final class CoinRowViewTests: XCTestCase {
  private let coin = DeveloperPreview.instance.coin

  func testCoinRowView() throws {
    let coinRowView = CoinRowView(
      coin: coin,
      showHoldings: false
    )

    let view: UIView = UIHostingController(rootView: coinRowView).view

    assertSnapshot(
      matching: view,
      as: .image(size: view.intrinsicContentSize)
    )
  }
}

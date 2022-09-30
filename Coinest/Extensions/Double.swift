//
//  Double.swift
//  Coinest
//
//  Created by Yuşa on 24.09.2022.
//

import Foundation

extension Double {
  /// Converts a Double to a 2-digits currency price.
  /// ```
  /// Convert 1234.56 to $1,234.56
  /// ```
  private var currencyFormatter2: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
  }

  /// Converts a Double to a 2 to 6-digits currency price as String.
  /// ```
  /// Convert 1234.56 to "$1,234.56"
  /// ```
  func asCurrencyWith2Decimals() -> String {
    let number = NSNumber(value: self)
    return currencyFormatter2.string(from: number).orEmptyPrice
  }

  /// Converts a Double to a 2 to 4-digits currency price.
  /// ```
  /// Convert 1234.56 to $1,234.56
  /// Convert 12.3456 to $12.3456
  /// Convert 0.123456 to $0.1234
  /// ```
  private var currencyFormatter4: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 4
    return formatter
  }

  /// Converts a Double to a 2 to 4-digits currency price as String.
  /// ```
  /// Convert 1234.56 to "$1,234.56"
  /// Convert 12.3456 to "$12.3456"
  /// Convert 0.123456 to "$0.1234"
  /// ```
  func asCurrencyWith4Decimals() -> String {
    let number = NSNumber(value: self)
    return currencyFormatter4.string(from: number).orEmptyPrice
  }

  /// Converts a Double to String representation.
  /// ```
  /// Convert 1.2345 to "$1.23"
  /// ```
  func asNumberString() -> String {
    String(format: "%.2f", self)
  }

  /// Converts a Double to String representation with the percent symbol (%).
  /// ```
  /// Convert 1.2345 to "1.23%"
  /// ```
  func asPercentString() -> String {
    asNumberString().appending("%")
  }
}

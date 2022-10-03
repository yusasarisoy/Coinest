//
//  Double.swift
//  Coinest
//
//  Created by Yuşa on 24.09.2022.
//

import Foundation

extension Double {
  var toString: String {
    "\(self)"
  }

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

  /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
  /// ```
  /// Convert 12 to 12.00
  /// Convert 1234 to 1.23K
  /// Convert 123456 to 123.45K
  /// Convert 12345678 to 12.34M
  /// Convert 1234567890 to 1.23Bn
  /// Convert 123456789012 to 123.45Bn
  /// Convert 12345678901234 to 12.34Tr
  /// ```
  func formattedWithAbbreviations() -> String {
    let num = abs(self)
    let sign: String = (self < .zero) ? .hyphen : .empty

    switch num {
    case 1_000_000_000_000...:
      let formatted = num / 1_000_000_000_000
      let stringFormatted = formatted.asNumberString()
      return "\(sign)\(stringFormatted)Tr"
    case 1_000_000_000...:
      let formatted = num / 1_000_000_000
      let stringFormatted = formatted.asNumberString()
      return "\(sign)\(stringFormatted)Bn"
    case 1_000_000...:
      let formatted = num / 1_000_000
      let stringFormatted = formatted.asNumberString()
      return "\(sign)\(stringFormatted)M"
    case 1_000...:
      let formatted = num / 1_000
      let stringFormatted = formatted.asNumberString()
      return "\(sign)\(stringFormatted)K"
    case 0...:
      return asNumberString()

    default:
      return "\(sign)\(self)"
    }
  }
}

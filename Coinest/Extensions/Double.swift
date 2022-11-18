import Foundation

extension Double {
  var toString: String {
    "\(self)"
  }

  var toPercentageChange: Double {
    self * 100
  }

  /// Converts a Double to a 2-digits currency price.
  /// ```
  /// Convert 1234.56 to $1,234.56
  /// ```
  private var currencyFormatter2: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
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
    return currencyFormatter2.string(from: number).orEmptyPrice.prependDollarSign
  }

  /// Converts a Double to a 2 to 6-digits currency price.
  /// ```
  /// Convert 1234.56 to $1,234.56
  /// Convert 12.3456 to $12.3456
  /// Convert 0.123456 to $0.123456
  /// ```
  private var currencyFormatter6: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 6
    return formatter
  }

  /// Converts a Double to a 2 to 6-digits currency price as String.
  /// ```
  /// Convert 1234.56 to "$1,234.56"
  /// Convert 12.3456 to "$12.3456"
  /// Convert 0.123456 to "$0.123456"
  /// ```
  func asCurrencyWith6Decimals() -> String {
    let number = NSNumber(value: self)
    return currencyFormatter6.string(from: number).orEmptyPrice.prependDollarSign
  }

  /// Converts a Double to String representation.
  /// ```
  /// Convert 1.2345 to "$1.23"
  /// ```
  func asNumberString() -> String {
    let isInteger = self == floor(self)
    return String(format: isInteger ? "%.0f" : "%.2f", self)
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

  static func updateTriangleRotation(_ change: Double) -> Double {
    switch change {
    case let change where change > 0:
      return 0
    case let change where change < 0:
      return 180
    default:
      return 90
    }
  }
}

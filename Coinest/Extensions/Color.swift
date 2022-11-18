import SwiftUI

extension Color {
  static let theme = ColorTheme()

  static func optColorBasedOnChange(_ percentChange: Double) -> Color {
    switch percentChange {
    case let change where change > 0:
      return Color.theme.green
    case let change where change < 0:
      return Color.theme.red
    default:
      return .gray
    }
  }
}

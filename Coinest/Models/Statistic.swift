import Foundation

struct Statistic: Identifiable {
  // MARK: - Properties
  let id = UUID().uuidString
  let title: String
  let value: String
  let change: Double?

  // MARK: - Initialization
  init(title: String, value: String, change: Double? = nil) {
    self.title = title
    self.value = value
    self.change = change
  }
}

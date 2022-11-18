import Foundation

extension String {
  func localized(_ language: String) -> String? {
    guard
      let path = Bundle.main.path(forResource: language, ofType: "lproj"),
      let bundle = Bundle(path: path)
    else {
      return nil
    }

    return NSLocalizedString(
      self,
      tableName: nil,
      bundle: bundle,
      value: "",
      comment: ""
    )
  }
}

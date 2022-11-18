import UIKit

extension UIApplication {
  func endEditing() {
    sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: .none,
      from: .none,
      for: .none
    )
  }
}

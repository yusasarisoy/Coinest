//
//  UIApplication.swift
//  Coinest
//
//  Created by Yuşa on 30.09.2022.
//

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

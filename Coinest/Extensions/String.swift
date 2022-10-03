//
//  String.swift
//  Coinest
//
//  Created by Yuşa on 30.09.2022.
//

extension String {
  static var empty: String {
    ""
  }

  static var hyphen: String {
    "-"
  }

  static var orEmptyPrice: String {
    "$0.00"
  }

  var prependDollarSign: String {
    "$\(String.init(describing: self))"
  }
}

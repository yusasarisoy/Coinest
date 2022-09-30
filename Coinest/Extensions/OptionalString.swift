//
//  OptionalString.swift
//  Coinest
//
//  Created by Yuşa on 24.09.2022.
//

extension Optional where Wrapped == String {
  var orEmpty: String {
    self ?? .empty
  }

  var orEmptyPrice: String {
    self ?? "$0.00"
  }
}

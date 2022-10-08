//
//  OptionalDouble.swift
//  Coinest
//
//  Created by Yuşa on 23.09.2022.
//

extension Optional where Wrapped == Double {
  var orZero: Double {
    self ?? 0
  }

  var isNil: Bool {
    self == .none
  }

  var toInt: Int {
    Int(self.orZero)
  }

  var toString: String {
    "\(self.orZero)"
  }

  var toPercentage: Double {
    self.orZero / 100
  }
}

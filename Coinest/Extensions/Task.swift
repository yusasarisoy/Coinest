//
//  Task.swift
//  Coinest
//
//  Created by Yuşa on 5.10.2022.
//

extension Task where Success == Never, Failure == Never {
  static func sleep(withSeconds seconds: Double) async throws {
    let duration = UInt64(seconds * 1_000_000_000)
    try await Task.sleep(nanoseconds: duration)
  }
}

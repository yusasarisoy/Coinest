//
//  XMarkButton.swift
//  Coinest
//
//  Created by Yuşa on 5.10.2022.
//

import SwiftUI

struct XMarkButton: View {
  // MARK: - Properties
  @Environment(\.dismiss) private var dismiss

  // MARK: - View
  var body: some View {
    Button(action: {
      dismiss()
    }, label: {
      Image(systemName: IconNaming.shared.xMark)
        .font(.headline)
    })
  }
}

// MARK: - Preview
struct XMarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XMarkButton()
  }
}

extension String {
  static var empty: String {
    ""
  }

  static var hyphen: String {
    "-"
  }

  static var emptyPrice: String {
    "$0.00"
  }

  var prependDollarSign: String {
    "$\(String.init(describing: self))"
  }
}

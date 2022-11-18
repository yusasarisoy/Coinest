extension Optional where Wrapped == String {
  var orEmpty: String {
    self ?? .empty
  }

  var orEmptyPrice: String {
    self ?? "$0.00"
  }
}

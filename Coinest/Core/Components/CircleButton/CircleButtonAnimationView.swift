import SwiftUI

struct CircleButtonAnimationView: View {
  // MARK: - Properties
  @Binding var animate: Bool

  // MARK: - View
  var body: some View {
    Circle()
      .stroke(lineWidth: 2)
      .scale(animate ? 1 : 0)
      .opacity(animate ? 0 : 1)
      .animation(animate ? .easeOut(duration: 1) : .none, value: animate)
  }
}

// MARK: - Preview
struct CircleButtonAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonAnimationView(animate: .constant(false))
      .foregroundColor(.red)
      .frame(width: 100, height: 100)
  }
}

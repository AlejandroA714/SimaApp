import SwiftUI

struct NavBarView: View {
    @Binding var index: Int

    var body: some View {
        HStack {
            navigationButton(index: 0, fill: "map.fill", outline: "map")
            navigationButton(index: 1, fill: "externaldrive.fill.badge.wifi", outline: "externaldrive.badge.wifi")
            navigationButton(index: 2, fill: "bell.fill", outline: "bell")
            navigationButton(index: 3, fill: "externaldrive.fill.badge.timemachine", outline: "externaldrive.badge.timemachine")
            navigationButton(index: 4, fill: "person.badge.key.fill", outline: "person.badge.key")
        }
        .padding(11)
        .frame(
            maxWidth: .infinity,
            maxHeight: min(max(UIScreen.main.bounds.height * 0.05, 24), 56)
        )
        .background(Color.primaryColor)
        .foregroundColor(.white)
    }

    @ViewBuilder
    func navigationButton(index: Int, fill: String, outline: String) -> some View {
        Button(action: { self.index = index }) {
            Image(systemName: self.index == index ? fill : outline)
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavBarView(index: .constant(0))
}

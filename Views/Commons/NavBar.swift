import SwiftUI

struct NavBarView: View {
    @Binding var index: Int

    var body: some View {
        HStack {
            Button(action: { index = 0 }) {
                Image(systemName: index == 0 ? "map.fill" : "map")
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: { index = 1 }) {
                Image(systemName: index == 1 ? "externaldrive.fill.badge.wifi" : "externaldrive.badge.wifi")
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: { index = 2 }) {
                Image(systemName: index == 2 ? "bell.fill" : "bell")
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: { index = 3 }) {
                Image(systemName: index == 3 ? "externaldrive.fill.badge.timemachine" : "externaldrive.badge.timemachine")
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: { index = 4 }) {
                Image(systemName: index == 4 ? "person.badge.key.fill" : "person.badge.key")
                    .resizable()
                    .scaledToFit()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(11)
        .frame(
            maxWidth: .infinity,
            maxHeight: min(max(UIScreen.main.bounds.height * 0.05, 24), 56)
        )
        .background(Color.primaryColor)
        .foregroundColor(.white)
    }
}

#Preview {
    NavBarView(index: .constant(0))
}

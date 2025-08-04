import SwiftUI

struct MapControlView: View {
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {}) {
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(10)
            }
            .clipShape(Rectangle())
            Divider()
                .frame(height: 2)
                .background(Color.gray.opacity(0.3))
            Button(action: {}) {
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(10)
            }
            .clipShape(Rectangle())
        }
        .background(Color(.systemBackground))
        .frame(width: 50)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }
}

#Preview {
    MapControlView()
}

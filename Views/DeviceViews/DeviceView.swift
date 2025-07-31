import SwiftUI

struct DeviceView: View {
    @EnvironmentObject private var viewModel: MapViewModel

    var body: some View {
        NavigationView {
            List(viewModel.entities, id: \.id) { item in
                Text(item.id)
            }
            .navigationTitle("Dispositivos")
        }
    }
}

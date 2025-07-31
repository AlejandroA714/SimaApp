import SwiftUI

struct DeviceView: View {
    @EnvironmentObject private var AppState: AppStateModel

    var body: some View {
        NavigationView {
            List($AppState.entities, id: \.id) { item in
                Text(item.id)
            }
            .navigationTitle("Dispositivos")
        }
    }
}

import SwiftUI

struct DeviceView: View {
    @ObservedObject private var AppState: AppStateModel

    init(_ appState: AppStateModel) {
        AppState = appState
    }

    var body: some View {
        NavigationView {
            List(AppState.entities, id: \.self) { item in
                Text(item.id)
            }
            .navigationTitle("Dispositivos")
        }
    }
}

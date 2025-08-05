import SwiftUI

struct DeviceView: View {
    @ObservedObject private var appState: AppStateModel

    init(_ state: AppStateModel) {
        _appState = ObservedObject(initialValue: state)
    }

    var body: some View {
        NavigationView {
            List(appState.entities, id: \.self) { item in
                Text(item.id)
            }
            .navigationTitle("Dispositivos")
        }
    }
}

import SwiftUI

struct AlertView: View {
    @ObservedObject private var AppState: AppStateModel

    init(_ appState: AppStateModel) {
        AppState = appState
    }

    var body: some View {
        Text("Alert View")
    }
}

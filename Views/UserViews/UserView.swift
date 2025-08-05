import SwiftUI

struct UserView: View {
    @ObservedObject private var appState: AppStateModel

    init(_ state: AppStateModel) {
        _appState = ObservedObject(initialValue: state)
    }

    var body: some View {
        Text("UserView")
    }
}

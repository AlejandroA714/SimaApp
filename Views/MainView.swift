import SwiftUI

struct MainView: View {
    @StateObject private var AppState: AppStateModel
    @StateObject private var webSocket: WebSocket

    init() {
        let AppState = AppStateModel()
        let Websocket = WebSocket(AppState)
        //
        _AppState = StateObject(wrappedValue: AppState)
        _webSocket = StateObject(wrappedValue: Websocket)
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch AppState.navigationIndex {
                case 0: MapView(AppState)
                case 1: DeviceView(AppState)
                case 2: AlertView(AppState)
                case 3: SubscriptionView(AppState)
                case 4: LoadingButton(AppState)
                default: MapView(AppState)
                }
            }
            .environmentObject(AppState)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            NavBarView(index: $AppState.navigationIndex)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppStateModel())
}

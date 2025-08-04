import SwiftUI

struct MainView: View {
    @StateObject var AppState: AppStateModel

    @StateObject private var mapModel: MapViewModel

    @StateObject private var webSocket: WebSocket

    init() {
        let AppState = AppStateModel()
        let Websocket = WebSocket(AppState)
        let MapModel = MapViewModel(AppState)
        //
        _AppState = StateObject(wrappedValue: AppState)
        _webSocket = StateObject(wrappedValue: Websocket)
        _mapModel = StateObject(wrappedValue: MapModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch AppState.navigationIndex {
                case 0: MapView()
                case 1: DeviceView()
                case 2: AlertView()
                case 3: SubscriptionView()
                case 4: LoadingButton()
                default: MapView()
                }
            }
            .environmentObject(AppState)
            .environmentObject(mapModel)
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

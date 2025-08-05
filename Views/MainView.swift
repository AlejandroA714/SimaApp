import SwiftUI

struct MainView: View {
    @StateObject private var appState: AppStateModel
    @StateObject private var webSocket: WebSocket

    init() {
        let AppState = AppStateModel()
        let Websocket = WebSocket(AppState)
        _appState = StateObject(wrappedValue: AppState)
        _webSocket = StateObject(wrappedValue: Websocket)
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch appState.navigationIndex {
                case 0: MapView(appState)
                case 1: DeviceView(appState)
                case 2: AlertView(appState)
                case 3: SubscriptionView(appState)
                case 4: LoadingButton(appState)
                default: MapView(appState)
                }
            }.alert(isPresented: Binding<Bool>(
                get: { appState.networkError != nil },
                set: { if !$0 { appState.networkError = nil }
                }
            )
            ) {
                SwiftUI.Alert(
                    title: Text("Error"),
                    message: Text(appState.networkError ?? "Error desconocido"),
                    dismissButton: .default(Text("Vale"), action: { appState.networkError = nil })
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            NavBarView(index: $appState.navigationIndex)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppStateModel())
}

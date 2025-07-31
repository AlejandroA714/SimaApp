import SwiftUI

struct MainView: View {
    
    @StateObject var  AppState: AppStateModel
    
    @StateObject private var mapVM: MapViewModel

    @StateObject private var webSocket: WebSocket = .init()

    init() {
        let AppState: AppStateModel = AppStateModel()
        _AppState = StateObject(wrappedValue: AppState)
        let dd = MapViewModel(AppState)
        //_webSocket = StateObject(wrappedValue: ws)
        _mapVM = StateObject(wrappedValue: dd)
        
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch AppState.navigationIndex {
                case 0: MapView()
                case 1: DeviceView()
                case 2: AlertView()
                case 3: SubscriptionView()
                case 4: LoadingButton()
                default: MapView()
                }
            }.environmentObject(AppState)
                .environmentObject(mapVM)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: -UIScreen.main.bounds.height * 0.05)
                .background(Color(.systemBackground))
            NavBarView(index: $AppState.navigationIndex)
        }
    }
}

#Preview {
    MainView()
}

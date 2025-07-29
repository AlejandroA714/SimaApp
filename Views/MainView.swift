import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedIndex {
                case 0: MapView()
                case 1: DeviceView()
                case 2: AlertView()
                case 3: SubscriptionView()
                case 4: LoadingButton()
                default: MapView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: -UIScreen.main.bounds.height * 0.05)
            .background(Color(.systemBackground))
            NavBarView(index: $selectedIndex)
        }
    }
}
    
#Preview {
    MainView()
}


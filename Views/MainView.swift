import SwiftUI

struct MainView: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedIndex {
                case 0: ContentView()
                case 1: AlgoView()
                case 2: ContentView()
                case 3: AlgoView()
                default: ContentView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            NavBarView(index: $selectedIndex)
        }
    }
}
    
#Preview {
    MainView()
}


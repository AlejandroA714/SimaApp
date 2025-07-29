import SwiftUI

struct NavBarView: View {
    
    @Binding var index: Int

    var body: some View {
        HStack {
            // MAP
            Button(action: {index = 0}){
                Image(systemName: index == 0 ? "map.fill" : "map")
                .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // DEVICES
            Button(action: {index = 1}){
                Image(systemName: index == 1 ? "externaldrive.fill.badge.wifi" : "externaldrive.badge.wifi")
                .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // ALERTS
            Button(action: {index = 2}){
                Image(systemName: index == 2 ? "bell.fill" : "bell")
                .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // SUBSCRIPTIONS
            Button(action: {index = 3}){
                Image(systemName: index == 3 ? "externaldrive.fill.badge.timemachine" : "externaldrive.badge.timemachine")
                .imageScale(.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(
           maxWidth: .infinity,
           maxHeight: UIScreen.main.bounds.height * 0.0225 // MAX HEIGHT 1% SCREEN
        )
        .padding()
        .background(Color.primaryColor)
        .foregroundColor(.white)
    }
}

#Preview {
    NavBarView(index: .constant(0))
}

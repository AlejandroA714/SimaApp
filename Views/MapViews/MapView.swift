import SwiftUI
import GoogleMaps

struct MapView: View {
    
    @State private var selectedType: GMSMapViewType = .hybrid
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GoogleMapWrapper(selectedType: $selectedType)
                        .edgesIgnoringSafeArea(.all)
                   Picker("Tipo de mapa", selection: $selectedType) {
                       Text("Normal").tag(GMSMapViewType.normal)
                       Text("Híbrido").tag(GMSMapViewType.hybrid)
                       Text("Satélite").tag(GMSMapViewType.satellite)
                       Text("Terreno").tag(GMSMapViewType.terrain)
                   }
                   .pickerStyle(MenuPickerStyle())
                   .background(Color.white.opacity(0.9))
                   .clipShape(RoundedRectangle(cornerRadius: 8))
                   .shadow(radius: 3)
                   .padding()
               }
        
    }
}

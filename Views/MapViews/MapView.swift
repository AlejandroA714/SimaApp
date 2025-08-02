import GoogleMaps
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    @EnvironmentObject var AppState: AppStateModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GoogleMapWrapper(selectedType: $AppState.mapType, entities: $AppState.entities)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    guard AppState.servicesPath.isEmpty else { return }
                    viewModel.loadEntities()
                }
            Picker("Tipo de mapa", selection: $AppState.selectedPath) {
                Text("/#").tag("/#")
                ForEach(AppState.servicesPath, id: \.self) { service in
                    Text(service)
                }
            }.onChange(of: AppState.selectedPath) { oldValue, newValue in
                print("🌍 Cambio de \(oldValue) → \(newValue)")
                viewModel.loadEntities()
            }.onChange(of: AppState.entities) { oldValue, newValue in
                //print("🌍 Cambio de \(oldValue) → \(newValue)")
                print("Actualizacion recibida")
            }
            .onAppear {
                guard AppState.entities.isEmpty else { return }
                viewModel.loadNgsi()
            }
            .pickerStyle(MenuPickerStyle())
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 3)
            .padding()
        }
    }
}

#Preview {
    MapView()
}

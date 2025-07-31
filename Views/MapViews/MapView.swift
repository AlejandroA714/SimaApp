import GoogleMaps
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel

    @EnvironmentObject var webSocket: WebSocket

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GoogleMapWrapper(selectedType: .constant(GMSMapViewType.terrain), entities: $viewModel.entities)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    guard viewModel.servicesPath.isEmpty else { return }
                    viewModel.loadEntities()
                }
            Picker("Tipo de mapa", selection: $viewModel.selectedType) {
                Text("/#").tag("/#")
                ForEach(viewModel.servicesPath, id: \.self) { service in
                    Text(service)
                }
            }.onChange(of: viewModel.selectedType) { oldValue, newValue in
                print("🌍 Cambio de \(oldValue) → \(newValue)")
                viewModel.loadEntities()
            }
            .onAppear {
                guard viewModel.entities.isEmpty else { return }
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

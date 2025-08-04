import GoogleMaps
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel

    @EnvironmentObject var appState: AppStateModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GoogleMapWrapper(selectedType: $appState.mapType, entities: $appState.entities)
                .ignoresSafeArea()
                .onAppear {
                    guard appState.servicesPath.isEmpty else { return }
                    viewModel.loadEntities()
                }
            VStack(alignment: .trailing) {
                MapControlView()
                Spacer()
                Picker("Path", selection: $appState.selectedPath) {
                    Text("/#").tag("/#")
                    ForEach(appState.servicesPath, id: \.self) { service in
                        if service == appState.selectedPath {
                            Text("/" + (service.components(separatedBy: "/").last ?? service))
                                .tag(service)
                        } else {
                            Text(service)
                                .tag(service)
                        }
                    }
                }.onChange(of: appState.selectedPath) { oldValue, newValue in
                    print("🌍 Cambio de \(oldValue) → \(newValue)")
                    viewModel.loadEntities()
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 100, maxHeight: 40, alignment: .center)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 3)

            }.padding()
        }.onAppear {
            guard appState.entities.isEmpty else { return }
            viewModel.loadNgsi()
        }
    }
}

#Preview {
    let appStateModel: AppStateModel = .init()
    let mapViewModel = MapViewModel(appStateModel)
    MapView()
        .environmentObject(appStateModel)
        .environmentObject(mapViewModel)
}

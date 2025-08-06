import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject private var mapViewModel: MapViewModel
    @ObservedObject private var appState: AppStateModel

    init(_ state: AppStateModel) {
        _appState = ObservedObject(initialValue: state)
        _mapViewModel = StateObject(wrappedValue: MapViewModel(state, DefaultEntitiesService()))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GoogleMapWrapper(selectedType: appState.mapTypeBinding, entities: appState.entitiesBinding)
                .ignoresSafeArea()
                .onAppear {
                    guard appState.servicesPath.isEmpty else { return }
                    mapViewModel.loadEntities()
                }
            VStack(alignment: .trailing) {
                MapControlView(appState)
                Spacer()
                Picker("Path", selection: appState.selectedPathBinding) {
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
                    mapViewModel.loadEntities()
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 100, maxHeight: 40, alignment: .center)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 3)

            }.padding()
        }
        .onAppear {
            guard appState.entities.isEmpty else { return }
            mapViewModel.loadNgsi()
        }
    }
}

#Preview {
    MapView(.init())
}

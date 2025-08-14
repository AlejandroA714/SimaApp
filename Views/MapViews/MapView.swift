import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject private var mapViewModel: MapViewModel
    @ObservedObject private var appState: AppStateModel
    @State private var selectedEntity: MarkerKey? = nil

    init(_ state: AppStateModel) {
        _appState = ObservedObject(initialValue: state)
        _mapViewModel = StateObject(wrappedValue: MapViewModel(state, DefaultEntitiesService()))
    }

    var body: some View {
        ZStack {
            GoogleMapWrapper(
                selectedType: appState.mapTypeBinding,
                entities: appState.entitiesBinding,
                selectedEntity: $selectedEntity
            )
            .ignoresSafeArea()
            .onAppear {
                if appState.entities.isEmpty {
                    mapViewModel.loadEntities()
                }
            }
            VStack {
                HStack {
                    MapControlView(appState)
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .leading], 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            if selectedEntity != nil {
                VStack {
                    HStack {
                        Spacer()
                        InfoMapWindow(entity: appState.entities.first(where: { $0.id == selectedEntity?.id && $0.type == selectedEntity?.type }),
                                      onClear: { selectedEntity = nil })
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeOut(duration: 0.2), value: selectedEntity?.id)
                            .onChange(of: selectedEntity?.id) { _, newValue in
                                print("Entity: \(String(describing: newValue)) Updated")
                            }
                    }
                    Spacer()
                }
                .padding([.top, .trailing], 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Picker("Path", selection: appState.selectedPathBinding) {
                        Text("/#").tag("/#")
                        ForEach(appState.servicesPath, id: \.self) { service in
                            if service == appState.selectedPath {
                                Text("/" + (service.components(separatedBy: "/").last ?? service))
                                    .tag(service)
                            } else {
                                Text(service).tag(service)
                            }
                        }
                    }
                    .onChange(of: appState.selectedPath) { _, _ in
                        mapViewModel.loadEntities()
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 140, maxHeight: 40)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 3)
                }
            }
            .padding([.trailing, .bottom], 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .onAppear {
            if appState.servicesPath.isEmpty { mapViewModel.loadPath() }
        }
    }
}

#Preview {
    MapView(.init())
}

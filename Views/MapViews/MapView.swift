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
            ).ignoresSafeArea()
            VStack(alignment: .trailing) {
                HStack {
                    MapControlView(appState)
                }
                Spacer()
                HStack {
                    PathPicker(appState.selectedPathBinding, appState.servicesPath)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            InfoMapWindow(entity: appState.entities.first(where: { $0.id == selectedEntity?.id && $0.type == selectedEntity?.type }),
                          onClear: { selectedEntity = nil })
        }
    }
}

#Preview {
    MapView(.init())
}

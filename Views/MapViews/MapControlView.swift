import GoogleMaps
import SwiftUI

struct MapControlView: View {
    @State private var showOverlay: Bool = false
    @State private var showLabels: Bool = true
    @ObservedObject var appState: AppStateModel

    init(_ state: AppStateModel) {
        _appState = ObservedObject(initialValue: state)
    }

    var body: some View {
        ZStack {
            controlPanel
            if showOverlay {
                overlayBackground
                mapTypeSelector
            }
        }
    }
}

private extension MapControlView {
    var controlPanel: some View {
        VStack(spacing: 0) {
            Button(action: { showOverlay = true }) {
                Image(systemName: "map.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(10)
            }
            .clipShape(Rectangle())
            Divider().frame(height: 2).background(Color.gray.opacity(0.3))
            Button(action: { MapController.shared.centerContent(to: appState.entities.coordinates()) }) {
                Image(systemName: "location.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(10)
            }
            .clipShape(Rectangle())
        }
        .background(Color(.systemBackground))
        .frame(width: 50)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3)
    }

    var overlayBackground: some View {
        Color.black.opacity(0.01)
            .ignoresSafeArea()
            .onTapGesture { closeOverlay() }
    }

    var mapTypeSelector: some View {
        VStack {
            HStack {
                selectableImage("NormalType", title: "Normal",
                                isSelected: appState.mapType == .normal,
                                type: .normal)

                selectableImage("SatelliteType", title: "Híbrido",
                                isSelected: [.hybrid, .satellite].contains(appState.mapType),
                                type: .hybrid, showOptions: true)
            }

            HStack {
                selectableImage("TerrainType", title: "Relieve",
                                isSelected: appState.mapType == .terrain,
                                type: .terrain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private extension MapControlView {
    @ViewBuilder
    func selectableImage(
        _ name: String,
        title: String,
        isSelected: Bool,
        type: GMSMapViewType,
        showOptions: Bool = false
    ) -> some View {
        VStack(spacing: 5) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
                .onTapGesture { selectMapType(type) }

            HStack(spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)

                if showOptions { hybridOptionsMenu(for: type) }
            }
        }
        .padding(5)
    }
}

private extension MapControlView {
    func hybridOptionsMenu(for type: GMSMapViewType) -> some View {
        Menu {
            Button {
                toggleLabels(for: type)
            } label: {
                HStack {
                    Text("Mostrar Etiquetas")
                    if showLabels { Image(systemName: "checkmark") }
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
}

private extension MapControlView {
    func closeOverlay() {
        withAnimation(.spring()) { showOverlay = false }
    }

    func selectMapType(_ type: GMSMapViewType) {
        if type == .hybrid {
            appState.setMapType(showLabels ? .hybrid : .satellite)
        } else {
            appState.setMapType(type)
        }
        closeOverlay()
    }

    func toggleLabels(for type: GMSMapViewType) {
        showLabels.toggle()
        if type == .hybrid {
            appState.setMapType(showLabels ? .hybrid : .satellite)
        }
        closeOverlay()
    }
}

#Preview {
    MapControlView(.init())
}

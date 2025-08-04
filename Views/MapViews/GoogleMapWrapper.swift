import GoogleMaps
import SwiftUI

struct GoogleMapWrapper: UIViewRepresentable {
    @Binding var selectedType: GMSMapViewType

    @Binding var entities: [Entity]

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(options: KeyManager.buildOptions())
        mapView.delegate = context.coordinator
        KeyManager.applyExtraSettings(to: mapView)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context _: Context) {
        let selectedId = uiView.selectedMarker?.userData as? String
        uiView.clear()
        var bounds = GMSCoordinateBounds()
        var markers: [String: GMSMarker] = [:]

        for entity in entities {
            guard let loc = entity.location else { continue }
            let position = CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng)

            let marker = GMSMarker(position: position)
            marker.title = entity.type
            marker.snippet = "Id: \(entity.id) | Nivel: \(entity.level) | " +
                entity.variables.map { "\($0.name): \($0.value.value)" }.joined(separator: " | ")
            marker.icon = GMSMarker.markerImage(with: UIColor(hex: entity.color))
            marker.userData = entity.id
            marker.map = uiView

            markers[entity.id] = marker
            bounds = bounds.includingCoordinate(position)
        }

        uiView.mapType = selectedType
        if let id = selectedId, let marker = markers[id] {
            uiView.selectedMarker = marker
        } else {
            if !entities.isEmpty {
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                uiView.animate(with: update)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
            print("🟢 Marker tapped: \(marker.title ?? "")")
            return false
        }

        func mapView(_: GMSMapView, willMove _: Bool) {
            // if gesture { userHasMoved = true }
            print("🟢 Map Moved: ")
        }
    }
}

import GoogleMaps
import SwiftUI

struct GoogleMapWrapper: UIViewRepresentable {
    @Binding var selectedType: GMSMapViewType
    @Binding var entities: [Entity]
    @Binding var selectedEntity: Entity? // ✅ Para mostrar InfoMapWindow

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(options: KeyManager.buildOptions())
        mapView.delegate = context.coordinator
        KeyManager.applyExtraSettings(to: mapView)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context _: Context) {
        uiView.clear()
        var bounds = GMSCoordinateBounds()
        var markers: [String: GMSMarker] = [:]

        for entity in entities {
            guard let loc = entity.location else { continue }
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng))
            marker.userData = entity
            marker.icon = GMSMarker.markerImage(with: UIColor(hex: entity.color))
            marker.map = uiView
            markers[entity.id] = marker
            bounds = bounds.includingCoordinate(marker.position)
        }

        if !entities.isEmpty {
            uiView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapWrapper
        init(parent: GoogleMapWrapper) { self.parent = parent }

        func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let entity = marker.userData as? Entity {
                parent.selectedEntity = entity
            }
            return true
        }
    }
}

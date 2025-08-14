import GoogleMaps
import SwiftUI

struct GoogleMapWrapper: UIViewRepresentable {
    @Binding var selectedType: GMSMapViewType
    @Binding var entities: [Entity]
    @Binding var selectedEntity: MarkerKey?

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView(options: KeyManager.buildOptions())
        mapView.delegate = context.coordinator
        KeyManager.applyExtraSettings(to: mapView)
        MapController.shared.setupMapView(mapView)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.mapType = selectedType
        // ONLY CREATE FOR ENTITIES WITH LOCATION
        let validKeys: Set<MarkerKey> = Set(entities.compactMap { e in
            guard e.location != nil else { return nil }
            return MarkerKey(id: e.id, type: e.type)
        })
        // REMOVE MARKER IF ENTITY DOEST EXISTS
        for (key, marker) in context.coordinator.markers where !validKeys.contains(key) {
            marker.map = nil
            context.coordinator.markers.removeValue(forKey: key)
        }
        // UPDATE OR CREATE
        print("\(selectedEntity?.id ?? "Nulo")")
        for e in entities {
            guard let loc = e.location else { continue }
            let key = MarkerKey(id: e.id, type: e.type)
            let pos = CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng)
            if let m = context.coordinator.markers[key] {
                if m.position.latitude != pos.latitude || m.position.longitude != pos.longitude {
                    m.position = pos
                }
                m.icon = GMSMarker.markerImage(with: UIColor(hex: e.color))
                m.userData = e
                if m.map == nil { m.map = uiView }
            } else {
                let m = GMSMarker(position: pos)
                m.icon = GMSMarker.markerImage(with: UIColor(hex: e.color))
                m.userData = e
                m.map = uiView
                context.coordinator.markers[key] = m
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, GMSMapViewDelegate {
        var markers: [MarkerKey: GMSMarker] = [:]
        var parent: GoogleMapWrapper
        init(parent: GoogleMapWrapper) { self.parent = parent }

        func mapView(_: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let entity = marker.userData as? Entity {
                parent.selectedEntity = MarkerKey(id: entity.id, type: entity.type)
            }
            return true
        }
    }
}

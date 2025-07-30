import SwiftUI
import GoogleMaps

struct GoogleMapWrapper: UIViewRepresentable {
    
    @Binding var selectedType: GMSMapViewType;
    
    @Binding var entities:[Entity];
    
        func makeUIView(context: Context) -> GMSMapView {
            let mapView = GMSMapView(options: KeyManager.buildOptions())
            KeyManager.applyExtraSettings(to: mapView)
            return mapView
        }
        
        func updateUIView(_ uiView: GMSMapView, context: Context) {
            uiView.clear()
            var bounds = GMSCoordinateBounds()
            for entity in entities {
                guard entity.location != nil else { continue }
                let position = CLLocationCoordinate2D(latitude: entity.location!.lat, longitude: entity.location!.lng)
                       let marker = GMSMarker()
                       marker.position = CLLocationCoordinate2D(latitude: entity.location!.lat,
                                                                longitude: entity.location!.lng)
                       marker.title = entity.type
                       marker.snippet = "Nivel: \(entity.level)"
                       marker.icon = GMSMarker.markerImage(with: UIColor(hex: entity.color))
                       marker.map = uiView
                bounds = bounds.includingCoordinate(position)
                   }
            uiView.mapType = selectedType
            if !entities.isEmpty {
                   let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                   uiView.animate(with: update)
               }
            
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator()
        }
        
        class Coordinator: NSObject, GMSMapViewDelegate {
            func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
                print("🟢 Marker tapped: \(marker.title ?? "")")
                return true
            }
        }
    
}

import SwiftUI
import GoogleMaps

struct GoogleMapWrapper: UIViewRepresentable {
    var lat: Double
        var lng: Double
        var zoom: Float = 14
        
        func makeUIView(context: Context) -> GMSMapView {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom)
            //TODO: Replace With -init or -initWithOptions
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            mapView.delegate = context.coordinator
            mapView.isMyLocationEnabled = true
            return mapView
        }
        
        func updateUIView(_ uiView: GMSMapView, context: Context) {
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom)
            uiView.animate(to: camera)
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

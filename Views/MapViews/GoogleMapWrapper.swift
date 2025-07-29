import SwiftUI
import GoogleMaps

struct GoogleMapWrapper: UIViewRepresentable {
    
    @Binding var selectedType: GMSMapViewType;
    
        func makeUIView(context: Context) -> GMSMapView {
            let mapView = GMSMapView(options: KeyManager.buildOptions())
            KeyManager.applyExtraSettings(to: mapView)
            return mapView
        }
        
        func updateUIView(_ uiView: GMSMapView, context: Context) {
            uiView.mapType = selectedType
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

import Foundation
import GoogleMaps

enum KeyManager {
    static let GOOGLE_MAPS_API_KEY: String? =
        value(for: "GOOGLE_MAPS_API_KEY")

    static let API_BASE_URL: String? = value(for: "API_BASE_URL")

    private static func value(for key: String) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            return nil
        }
        return value
    }

    private static var config: [String: Any] {
        Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_OPTIONS") as? [String: Any] ?? [:]
    }

    static func buildOptions() -> GMSMapViewOptions {
        let options = GMSMapViewOptions()
        let lat = config["lat"] as? CLLocationDegrees ?? 0
        let lng = config["lng"] as? CLLocationDegrees ?? 0
        let zoom = Float(config["zoom"] as? Double ?? 14.0)
        options.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom)
        if let mapId = config["mapId"] as? String {
            options.mapID = GMSMapID(identifier: mapId)
        }
        return options
    }

    static func applyExtraSettings(to mapView: GMSMapView) {
        if let type = (config["mapTypeId"] as? String)?.lowercased() {
            switch type {
            case "satellite": mapView.mapType = .satellite
            case "terrain": mapView.mapType = .terrain
            case "hybrid": mapView.mapType = .hybrid
            default: mapView.mapType = .normal
            }
        }
        let currentMin = mapView.minZoom
        let currentMax = mapView.maxZoom
        let minZoom = (config["minZoom"] as? NSNumber)?.floatValue ?? currentMin
        let maxZoom = (config["maxZoom"] as? NSNumber)?.floatValue ?? currentMax
        mapView.setMinZoom(minZoom, maxZoom: maxZoom)
        if let scroll = config["scrollwheel"] as? Bool {
            mapView.settings.scrollGestures = scroll
        }
        if let disableDouble = config["disableDoubleClickZoom"] as? Bool {
            mapView.settings.zoomGestures = !disableDouble
        }
    }
}

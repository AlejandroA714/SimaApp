import GoogleMaps

final class MapController {
    // SINGLETON
    static let shared = MapController()
    private init() {}

    private(set) weak var mapView: GMSMapView?

    func setupMapView(_ mapView: GMSMapView) {
        self.mapView = mapView
    }

    func center(to: CLLocationCoordinate2D, animated: Bool = true) {
        guard let mv = mapView else { return }
        let u = GMSCameraUpdate.setTarget(to)
        animated ? mv.animate(with: u) : mv.moveCamera(u)
    }

    func centerContent(to coords: [CLLocationCoordinate2D?]) {
        guard let mv = mapView else { return }
        var bounds = GMSCoordinateBounds()
        for coord in coords {
            guard let c = coord else { continue }
            bounds = bounds.includingCoordinate(c)
        }
        let u = GMSCameraUpdate.fit(bounds, withPadding: 50)
        mv.animate(with: u)
    }

    func setType(_ t: GMSMapViewType) { mapView?.mapType = t }
}

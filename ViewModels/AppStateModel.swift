import SwiftUICore
import GoogleMaps

class AppStateModel: ObservableObject {
    @Published var selectedPath: String = "/#";
    
    @Published var entities: [Entity] = []
    
    @Published var navigationIndex: Int = 0
    
    @Published var mapType: GMSMapViewType = .hybrid
    
    var servicesPath: [String] = []
}

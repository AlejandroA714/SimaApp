import SwiftUI
import GoogleMaps

@main
struct SimaApp: App {
    
    init () {
        GMSServices.provideAPIKey(KeyManager.GOOGLE_MAPS_API_KEY)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

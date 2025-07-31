import GoogleMaps
import SwiftUI

@main
struct SimaApp: App {
    init() {
        guard let value = KeyManager.GOOGLE_MAPS_API_KEY else {
            fatalError("❌ Missing key: GOOGLE_MAPS_API_KEY in Info.plist")
        }
        GMSServices.provideAPIKey(value)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

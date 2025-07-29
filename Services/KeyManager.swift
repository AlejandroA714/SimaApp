import Foundation

enum KeyManager {
    private static func value(for key: String) -> String {
           guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
               fatalError("❌ Missing key: \(key) in Info.plist")
           }
           return value
       }
       
    static let GOOGLE_MAPS_API_KEY: String =
           value(for: "GOOGLE_MAPS_API_KEY")
}

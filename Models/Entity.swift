import CoreLocation
import Foundation

struct Entity: Codable, Identifiable {
    let id: String
    let type: String
    let level: Int
    let timeInstant: String
    let externalUri: String?
    let location: Location?
    let color: String
    let variables: [Variable]
}

struct Variable: Codable {
    let name: String
    let value: StringOrNumber
    let alert: Alert?
}

struct Alert: Codable {
    let name: String
    let color: String
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct StringOrNumber: Codable {
    let value: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        // ✅ Intenta decodificar como String
        if let str = try? container.decode(String.self) {
            value = str
        }
        // ✅ Si es número entero → conviértelo a String
        else if let int = try? container.decode(Int.self) {
            value = "\(int)"
        }
        // ✅ Si es número decimal → conviértelo a String
        else if let dbl = try? container.decode(Double.self) {
            value = "\(dbl)"
        }
        // ✅ Si es null u otro formato → String vacío
        else {
            value = ""
        }
    }
}

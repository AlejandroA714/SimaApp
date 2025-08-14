import CoreLocation
import Foundation

struct Entity: Codable, Hashable, Equatable {
    let id: String
    let type: String
    let level: Int
    let timeInstant: String
    let externalUri: String?
    let location: Location?
    let color: String
    let variables: [Variable]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
    }

    func coordinate() -> CLLocationCoordinate2D? {
        guard let location = location else { return nil }
        return CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }
}

extension Sequence where Element == Entity {
    func coordinates() -> [CLLocationCoordinate2D] {
        compactMap { $0.coordinate() }
    }
}

struct Variable: Codable, Hashable, Equatable {
    let name: String
    let value: StringOrNumber
    let alert: Alert?
}

struct Alert: Codable, Hashable, Equatable {
    let name: String
    let color: String
}

struct Location: Codable, Hashable, Equatable {
    let lat: Double
    let lng: Double
}

struct MarkerKey: Hashable {
    let id: String
    let type: String
}

struct StringOrNumber: Codable, Hashable, Equatable {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let str = try? container.decode(String.self) {
            value = str
        } else if let int = try? container.decode(Int.self) {
            value = "\(int)"
        } else if let dbl = try? container.decode(Double.self) {
            value = "\(dbl)"
        } else {
            value = ""
        }
    }
}

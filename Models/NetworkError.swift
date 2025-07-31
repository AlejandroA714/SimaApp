import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case requestFailed(Int)
    case decodingFailed
    case missingConfiguration
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .missingConfiguration: return "❌ Missing key: API_BASE_URL in Info.plist"
        case .badURL: return "URL inválida"
        case let .requestFailed(code): return "Error HTTP: \(code)"
        case .decodingFailed: return "Error al decodificar datos"
        case let .unknown(error): return error.localizedDescription
        }
    }
}

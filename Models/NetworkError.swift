import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case requestFailed(Int)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .badURL: return "URL inválida"
        case .requestFailed(let code): return "Error HTTP: \(code)"
        case .decodingFailed: return "Error al decodificar datos"
        case .unknown(let error): return error.localizedDescription
        }
    }
}

import Combine

protocol NetworkServiceProtocol {
    func get<T: Decodable>(_ endpoint: String, headers: [String: String]?) -> AnyPublisher<T, NetworkError>

    func post<T: Decodable, B: Encodable>(_ endpoint: String, body: B, headers: [String: String]?) -> AnyPublisher<T, NetworkError>
}

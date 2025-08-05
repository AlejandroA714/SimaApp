import Combine
import Foundation

class DefaultNetworkServie: NetworkServiceProtocol {
    private let httpProtocol: String = "https://"

    private func processURL(_ endpoint: String) -> URL? {
        guard let HTTP_URI = KeyManager.API_BASE_URL else { return nil }
        return URL(string: "\(httpProtocol)\(HTTP_URI)\(endpoint)") ?? nil
    }

    func get<T: Decodable>(_ endpoint: String, headers: [String: String]? = nil) -> AnyPublisher<T, NetworkError> {
        guard let url = processURL(endpoint) else {
            return Fail(error: .missingConfiguration).eraseToAnyPublisher()
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return execute(request)
    }

    func post<T: Decodable, B: Encodable>(_ endpoint: String, body: B, headers: [String: String]? = nil) -> AnyPublisher<T, NetworkError> {
        guard let url = processURL(endpoint) else {
            return Fail(error: .missingConfiguration).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try? JSONEncoder().encode(body)
        return execute(request)
    }

    private func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      (200 ..< 300).contains(response.statusCode)
                else {
                    throw NetworkError.requestFailed((output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                print(error)
                if let netErr = error as? NetworkError { return netErr }
                if error is DecodingError { return .decodingFailed }
                return .unknown(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

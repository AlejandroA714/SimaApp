import Combine
import Foundation
import SwiftUI

class WebSocket: ObservableObject {
    private let wsProtocol: String = "wss://"

    let entityPublisher = PassthroughSubject<Entity, Never>()
    // @Published var messages: [Entity] = []

    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        connect()
    }

    private func connect() {
        guard let WS_URI = KeyManager.API_BASE_URL else { print("WS_URI not set"); return }
        guard let url = URL(string: "\(wsProtocol)\(WS_URI)/v1/ngsi/ws/") else { print("Invalid URL"); return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }

    private func receiveMessage() {
        webSocketTask?.receive { result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(message):
                switch message {
                case let .string(text):
                    // print(text)

                    let messageData = text.data(using: .utf8)
                    let message = try? JSONDecoder().decode(Entity.self, from: messageData!)
                    self.entityPublisher.send(message!)
                // self.messages.append(message!)
                // print(message as Any)
                case .data:
                    print("BINARY DATA")
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
            }
                //if cant connect WOULD CAUSE RECURSION, INFINITE, SLOW DOWN APP
            // it makes recursive
           // self.receiveMessage()
        }
        // receiveMessage()
    }

    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

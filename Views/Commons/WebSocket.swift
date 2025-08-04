import Combine
import Foundation
import SwiftUI

class WebSocket: ObservableObject {
    @ObservedObject var AppState: AppStateModel

    private var cancellables = Set<AnyCancellable>()

    private let wsProtocol: String = "wss://"
    private var webSocketTask: URLSessionWebSocketTask?

    init(_ AppState: AppStateModel) {
        _AppState = .init(wrappedValue: AppState)
        connect()
        AppState.$selectedPath.sink { path in
            print("Se cambio el path actual: \(path)")
            self.sendMessage(path)
        }.store(in: &cancellables)
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
                    let messageData = text.data(using: .utf8)
                    let message = try? JSONDecoder().decode(Entity.self, from: messageData!)
                    self.AppState.emit(message!)
                    self.receiveMessage()
                case .data:
                    print("BINARY DATA")
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
            }
        }
    }

    func sendMessage(_ message: String) {
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

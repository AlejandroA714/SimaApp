import Combine
import Foundation
import SwiftUI

class WebSocket: ObservableObject {
    private let appState: AppStateModel

    private var cancellables = Set<AnyCancellable>()
    private let wsProtocol: String = "wss://"
    private var webSocketTask: URLSessionWebSocketTask?
    private var reconnectDelay: TimeInterval = 5
    private let decoder: JSONDecoder = .init()

    init(_ appState: AppStateModel) {
        self.appState = appState
        connect()
        appState.$selectedPath.onChangePair {
            [weak self] old, new in
            self?.sendMessage(new)
            print("[\(old ?? "")] -> [\(new)]")
        }.store(in: &cancellables)
    }

    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    func connectIfNeeded() {
        guard webSocketTask == nil || webSocketTask?.state != .running else { return }
        connect()
    }

    private func connect() {
        guard let WS_URI = KeyManager.API_BASE_URL else { print("WS_URI not set"); return }
        guard let url = URL(string: "\(wsProtocol)\(WS_URI)/v1/ngsi/ws/") else { print("Invalid URL"); return }
        let request = URLRequest(url: url)
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }

    private func receiveMessage() {
        guard let task = webSocketTask else {
            scheduleReconnect()
            return
        }
        guard task.state == .running else {
            print("SOCKET IS NOT RUNNING, RECONNECTING...")
            scheduleReconnect()
            return
        }
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                print("⚠️ WebSocket: mensaje inválido recibido: [\(error.localizedDescription)]")
                self.appState.setNetworkError("Se perdió la conexión con el servidor. Reintentando...")
                self.scheduleReconnect()
            case let .success(message):
                if let entity = self.decodeEntity(from: message) {
                    self.appState.emitUpdate(entity)
                } else {
                    print("⚠️ WebSocket: mensaje inválido recibido: [\(message)]")
                }
                self.reconnectDelay = 5
                self.receiveMessage()
            }
        }
    }

    private func scheduleReconnect() {
        let delay = reconnectDelay
        reconnectDelay = min(reconnectDelay * 2, 60)
        print("ℹ️ WebSocket: reconectando en \(Int(delay)) segundos...")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.connect()
        }
    }

    private func decodeEntity(from message: URLSessionWebSocketTask.Message) -> Entity? {
        switch message {
        case let .string(text):
            guard let data = text.data(using: .utf8) else { return nil }
            return try? decoder.decode(Entity.self, from: data)
        case let .data(data):
            return try? decoder.decode(Entity.self, from: data)
        @unknown default:
            return nil
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

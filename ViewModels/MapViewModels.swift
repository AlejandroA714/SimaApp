import Combine
import Foundation

class MapViewModel: ObservableObject {
    @Published var servicesPath: [String] = []

    @Published var selectedType: String = "/#"

    @Published var entities: [Entity] = []

    private var cancellables = Set<AnyCancellable>()

    private let prefixService: EntitiesProtocol = DefaultEntitiesService()

    init(_ webSocket: WebSocket) {
        // Suscribirse al WebSocket sin acoplamiento fuerte
        webSocket.entityPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entity in
                print("RECEIVED ON MAP VIEW MODEL")
                self?.entities.append(entity)
            }
            .store(in: &cancellables)
    }

    func loadEntities() {
        print("🔄 Cargando entidades del API...")
        prefixService.entities(servicePath: selectedType)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }

            }, receiveValue: { [weak self] values in
                self?.entities = values
            })
            .store(in: &cancellables)
    }

    func loadNgsi() {
        print("🔄 Cargando NGSI del API...")
        prefixService.servicesPath()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    // self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] values in
                self?.servicesPath = values
            })
            .store(in: &cancellables)
    }
}

import Combine
import GoogleMaps
import SwiftUI

class AppStateModel: ObservableObject {
    @Published private(set) var selectedPath: String = "/#"
    @Published private(set) var entities: [Entity] = []
    @Published private(set) var navigationIndex: Int = 0
    @Published private(set) var mapType: GMSMapViewType = .normal
    @Published private(set) var networkError: String?
    var servicesPath: [String] = []
    private let subject = PassthroughSubject<Entity, Never>()
    private var cancellables = Set<AnyCancellable>()

    private func makeBinding<T>(get: @escaping () -> T, set: @escaping (T) -> Void) -> Binding<T> {
        Binding(get: get, set: set)
    }

    private func updateOnMain<T>(_ keyPath: ReferenceWritableKeyPath<AppStateModel, T>, to value: T) {
        if Thread.isMainThread {
            self[keyPath: keyPath] = value
        } else {
            DispatchQueue.main.async {
                self[keyPath: keyPath] = value
            }
        }
    }

    var mapTypeBinding: Binding<GMSMapViewType> {
        makeBinding(get: { self.mapType }, set: { self.setMapType($0) })
    }

    var navigationIndexBinding: Binding<Int> {
        makeBinding(get: { self.navigationIndex }, set: { self.setNavigationIndex($0) })
    }

    var selectedPathBinding: Binding<String> {
        makeBinding(get: { self.selectedPath }, set: { self.setSelectedPath($0) })
    }

    var entitiesBinding: Binding<[Entity]> {
        makeBinding(get: { self.entities }, set: { self.setEntities($0) })
    }

    func setSelectedPath(_ path: String) {
        updateOnMain(\.selectedPath, to: path)
    }

    func setEntities(_ newEntities: [Entity]) {
        updateOnMain(\.entities, to: newEntities)
    }

    func setNetworkError(_ message: String?) {
        updateOnMain(\.networkError, to: message)
    }

    func setNavigationIndex(_ index: Int) {
        updateOnMain(\.navigationIndex, to: index)
    }

    func setMapType(_ type: GMSMapViewType) {
        guard mapType != type else { return }
        updateOnMain(\.mapType, to: type)
    }

    var entitiesUpdate: AnyPublisher<Entity, Never> {
        subject.eraseToAnyPublisher()
    }

    func emitUpdate(_ entity: Entity) {
        subject.send(entity)
    }

    init() {
        subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] entity in
                guard let self = self else { return }
                print(self.entities.count)
                print(entity.id)
                if let index = entities.firstIndex(where: { $0.id == entity.id && $0.type == entity.type }) {
                    entities[index] = entity
                } else {
                    entities.append(entity)
                }
                self.entities = entities
                print(self.entities.count)
            }.store(in: &cancellables)
    }
}

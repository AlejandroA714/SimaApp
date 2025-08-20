import Combine
import GoogleMaps
import SwiftUI
import UserNotifications

class AppStateModel: ObservableObject {
    @Published private(set) var selectedPath: String = "/#"
    @Published private(set) var entities: [Entity] = []
    @Published private(set) var navigationIndex: Int = 0
    @Published private(set) var mapType: GMSMapViewType = .normal
    @Published private(set) var networkError: String?
    var servicesPath: [String] = []
    private let subject = PassthroughSubject<Entity, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var debouncers: [String: AnyCancellable] = [:]
    private var latestLevelChange: [String: (old: Int, new: Int, entity: Entity)] = [:]
    private let debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .seconds(1)

    private func makeBinding<T>(get: @escaping () -> T, set: @escaping (T) -> Void) -> Binding<T> {
        Binding(get: get, set: set)
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
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

    private func buildAlertsSummary(for entity: Entity) -> String? {
        let items = entity.variables.compactMap { v -> String? in
            guard let a = v.alert else { return nil }
            return "\(v.name): \(v.value.value) (\(a.name))"
        }
        guard !items.isEmpty else { return nil }

        let head = items.prefix(3).joined(separator: " • ")
        return items.count > 3 ? "Alertas: \(head) (+\(items.count - 3) más)" : "Alertas: \(head)"
    }

    var mapTypeBinding: Binding<GMSMapViewType> {
        makeBinding(get: { self.mapType }, set: { self.setMapType($0) })
    }

    var navigationIndexBinding: Binding<Int> {
        makeBinding(get: { self.navigationIndex }, set: { self.setNavigationIndex($0) })
    }

    var selectedPathBinding: Binding<String> {
        makeBinding(get: { self.selectedPath }, set: { [weak self] newValue in
            guard let self = self, self.selectedPath != newValue else { return }
            self.setSelectedPath(newValue)
        })
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
                print("RECEIVED UPDATE: [\(entity.id)]")
                var list = entities
                let key = "\(entity.id)#\(entity.type)" // clave por entidad

                if let index = list.firstIndex(where: { $0.id == entity.id && $0.type == entity.type }) {
                    let oldEntity = list[index]
                    let oldLevel = oldEntity.level
                    let newLevel = entity.level
                    print("[\(oldLevel)] -> [\(newLevel)]")
                    // Solo si cambió el level (más alto o más bajo)
                    if newLevel != oldLevel {
                        // 1) Guarda el ÚLTIMO cambio pendiente por esta entidad
                        self.latestLevelChange[key] = (old: oldLevel, new: newLevel, entity: entity)

                        // 2) Cancela cualquier debounce pendiente y programa uno nuevo
                        self.debouncers[key]?.cancel()
                        self.debouncers[key] = Just(())
                            .delay(for: self.debounceInterval, scheduler: DispatchQueue.main)
                            .sink { [weak self] in
                                guard let self = self,
                                      let change = self.latestLevelChange[key] else { return }

                                // ← Aquí disparas la notificación con el último cambio acumulado
                                let wentUp = change.new > change.old
                                let title = wentUp ? "📈 Nivel subió" : "📉 Nivel bajó"
                                var body = "Entidad \(entity.id): \(oldLevel) → \(newLevel)" // tu contenido actual
                                if let alerts = buildAlertsSummary(for: entity) {
                                    body += "\n" + alerts
                                }
                                // Si ya tienes NotificationService:
                                NotificationService.shared.notify(
                                    title: "\(title) • \(change.entity.type)",
                                    body: body
                                )
                                self.debouncers[key] = nil
                            }
                    }

                    // Actualiza la entidad en la lista
                    list[index] = entity
                } else {
                    list.append(entity)
                }

                self.entities = list
            }.store(in: &cancellables)
    }

    private func sendLevelChangeNotification(oldLevel: Int, newLevel: Int, entity: Entity) {
        let wentUp = newLevel > oldLevel
        let title = wentUp ? "📈 Nivel subió" : "📉 Nivel bajó"
        NotificationService.shared.notify(
            title: "\(title) • \(entity.type)", // o 📉 si bajó
            body: "Entidad \(entity.id): \(oldLevel) → \(newLevel)"
        )
    }
}

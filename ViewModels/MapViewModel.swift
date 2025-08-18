import Combine
import Foundation
import SwiftUI

class MapViewModel: ObservableObject {
    private let appState: AppStateModel
    private let entitiesService: EntitiesProtocol
    private var cancellables = Set<AnyCancellable>()
    private var entitiesCancellable: AnyCancellable?

    init(_ appState: AppStateModel, _ service: EntitiesProtocol) {
        self.appState = appState
        entitiesService = service
        if appState.servicesPath.isEmpty { loadPath() }
        if appState.entities.isEmpty { loadEntities(appState.selectedPath) }
        appState.$selectedPath
            .onChange { [weak self] newPath in
                self?.loadEntities(newPath)
            }
            .store(in: &cancellables)
    }

    func loadEntities(_ path: String = "/#") {
        entitiesCancellable?.cancel()
        entitiesCancellable = entitiesService.entities(servicePath: path)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.appState.setNetworkError("Error de red: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] values in
                self?.appState.setEntities(values)
                MapController.shared.centerContent(to: values.coordinates())

            })
    }

    func loadPath() {
        entitiesService.servicesPath()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.appState.setNetworkError("Error de red: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] values in
                self?.appState.servicesPath = values
            })
            .store(in: &cancellables)
    }
}

import Combine
import Foundation
import SwiftUICore

class MapViewModel: ObservableObject {
    private let AppState: AppStateModel

    private let entitiesService: EntitiesProtocol

    private var cancellables = Set<AnyCancellable>()

    init(_ AppState: AppStateModel, _ service: EntitiesProtocol) {
        self.AppState = AppState
        entitiesService = service
    }

    func loadEntities() {
        entitiesService.entities(servicePath: AppState.selectedPath)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.AppState.networkError = "Error de red: \(error.localizedDescription)"
                }

            }, receiveValue: { [weak self] values in
                self?.AppState.entities = values
            })
            .store(in: &cancellables)
    }

    func loadNgsi() {
        entitiesService.servicesPath()
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.AppState.networkError = "Error de red: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] values in
                self?.AppState.servicesPath = values
            })
            .store(in: &cancellables)
    }
}

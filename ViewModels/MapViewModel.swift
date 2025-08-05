import Combine
import Foundation
import SwiftUICore

class MapViewModel: ObservableObject {
    private var AppState: AppStateModel

    private var cancellables = Set<AnyCancellable>()

    private let entitiesService: EntitiesProtocol

    init(_ AppState: AppStateModel, _ service: EntitiesProtocol) {
        self.AppState = AppState
        entitiesService = service
    }

    func loadEntities() {
        entitiesService.entities(servicePath: AppState.selectedPath)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }

            }, receiveValue: { [weak self] values in
                self?.AppState.entities = values
            })
            .store(in: &cancellables)
    }

    func loadNgsi() {
        entitiesService.servicesPath()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                    // self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] values in
                self?.AppState.servicesPath = values
            })
            .store(in: &cancellables)
    }
}

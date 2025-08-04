import Combine
import Foundation
import SwiftUICore

class MapViewModel: ObservableObject {
    @ObservedObject var AppState: AppStateModel

    private var cancellables = Set<AnyCancellable>()

    private let prefixService: EntitiesProtocol = DefaultEntitiesService()

    init(_ AppState: AppStateModel) {
        self.AppState = AppState
    }

    func loadEntities() {
        prefixService.entities(servicePath: AppState.selectedPath)
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
                self?.AppState.servicesPath = values
            })
            .store(in: &cancellables)
    }
}

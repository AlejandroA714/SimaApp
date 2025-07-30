import Foundation
import Combine

class MapViewModel: ObservableObject {
    
    @Published var servicesPath: [String] = []
    
    @Published var selectedType: String = "/SICA"
    
    @Published var entities: [Entity] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let prefixService: PrefixService
    
    init(prefixService: PrefixService = DefaultPrefixService()) {
          self.prefixService = prefixService
    }
    
    func loadEntities() {
        prefixService.entities(servicePath: selectedType)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }, receiveValue: { [weak self] values in
                self?.entities = values
            })
           .store(in: &cancellables)
    }
    
    func loadNgsi() {
        prefixService.servicesPath()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        //self?.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { [weak self] values in
                    self?.servicesPath = values
                })
                .store(in: &cancellables)
        }
    
    
    
    
    
    
    
}


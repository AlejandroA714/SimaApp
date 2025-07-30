import Combine

protocol EntitiesProtocol {
    func servicesPath() -> AnyPublisher<[String], NetworkError>

    func entities(servicePath: String) -> AnyPublisher<[Entity], NetworkError>
}

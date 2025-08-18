import Combine
import Foundation

class DefaultEntitiesService: EntitiesProtocol {
    private let web: NetworkServiceProtocol = DefaultNetworkService()

    func servicesPath() -> AnyPublisher<[String], NetworkError> {
        return web.get("/v1/ngsi/services-path", headers: ["X-Service": "sv"])
    }

    func entities(servicePath: String) -> AnyPublisher<[Entity], NetworkError> {
        return web.get("/v1/ngsi/entities", headers: ["X-Service": "sv", "X-Path": servicePath])
    }
}

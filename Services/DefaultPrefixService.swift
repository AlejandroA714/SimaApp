import Combine
import Foundation

class DefaultPrefixService: PrefixService {
    
    private let web: NetworkServiceProtocol = NetworkService()
        
    func servicesPath() -> AnyPublisher<[String], NetworkError> {
        return web.get("/v1/ngsi/services-path", headers: ["X-Service": "sv"])
    }
    
    func entities(servicePath: String) -> AnyPublisher<[Entity], NetworkError> {
        return web.get("/v1/ngsi/entities", headers: ["X-Service": "sv", "X-Path": servicePath])
    }
    
}

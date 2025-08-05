import Combine
import GoogleMaps
import SwiftUICore

class AppStateModel: ObservableObject {
    @Published var selectedPath: String = "/#"

    @Published var entities: [Entity] = []

    @Published var navigationIndex: Int = 0

    @Published var mapType: GMSMapViewType = .normal

    private var cancellables = Set<AnyCancellable>()

    var servicesPath: [String] = []

    private let subject = PassthroughSubject<Entity, Never>()

    var entityPublisher: AnyPublisher<Entity, Never> {
        subject.eraseToAnyPublisher()
    }

    func emit(_ entity: Entity) {
        subject.send(entity)
    }

    init() {
        let json = """
        {
            "id": "urn:ngsi-ld:RTUHW:103",
            "type": "RTUHW",
             "location": {
                 "lat": 13.715719242,
                 "lng": -88.15516124
             },
            "externalUri": "https://grafana.sima.udb.edu.sv/public-dashboards/aa4a2918a7664a869b014e3062723c1b",
            "color": "#e01b24",
            "level": 5,
            "variables": [
                {
                    "name": "Temperatura Aire",
                    "value": "42 °C",
                    "alert": {
                        "name": "Temperatura extrema",
                        "color": "#e01b24"
                    }
                },
                {
                    "name": "airHumi",
                    "value": 77
                },
                {
                    "name": "Presión atmosférica",
                    "value": "200 hPa"
                },
                {
                    "name": "Temperatura del suelo",
                    "value": "2.147483647E7 °C"
                },
                {
                    "name": "Humedad del Suelo",
                    "value": "2.147483647E7 %"
                },
                {
                    "name": "Velocidad del Viento",
                    "value": "0 m/s"
                },
                {
                    "name": "vocAir",
                    "value": 500000
                },
                {
                    "name": "Co2 en el Aire",
                    "value": "65000 ppm"
                },
                {
                    "name": "Particulado PM 1.0",
                    "value": "99 ppl"
                },
                {
                    "name": "Particulado PM 2.5",
                    "value": "99 ppl"
                },
                {
                    "name": "Particulado PM 10.0",
                    "value": "99 ppl",
                    "alert": {
                        "name": "Riesgo de mortalidad",
                        "color": "#e01b24"
                    }
                },
                {
                    "name": "Cantidad de lluvia",
                    "value": "0 mm",
                    "alert": {
                        "name": "Debiles",
                        "color": "#1a5fb4"
                    }
                },
                {
                    "name": "oriGeoX",
                    "value": 0
                },
                {
                    "name": "oriGeoY",
                    "value": 0
                },
                {
                    "name": "oriGeoZ",
                    "value": 0
                },
                {
                    "name": "Acelerometro X",
                    "value": "0 m/s²"
                },
                {
                    "name": "Acelerometro Y",
                    "value": "0 m/s²"
                },
                {
                    "name": "Acelerometro Z",
                    "value": "0 m/s²"
                }
            ],
            "timeInstant": "01/08/2025 04:55:25 PM"
        }
        """.data(using: .utf8)!
        subject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                // print("UPDATED EMITTED TO")
                print(self.entities.count)
                do {
                    let randomInt = Int.random(in: 0 ... 100)
                    var entity = try JSONDecoder().decode(Entity.self, from: json)
                    entity.level = randomInt
                    print(entity.id)
                    print(entity.level)
                    if let index = entities.firstIndex(where: { $0.id == entity.id && $0.type == entity.type }) {
                        // objectWillChange.send()
                        // var tempItems = entities
                        //        tempItems[index] = entity
                        entities[index] = entity
                        // entities.remove(at: index)
                        // entities.append(entity)
                        // entities = Array(entities) // ✅ Forzar redibujado
                    } else {
                        entities.append(entity)
                    }
                    // print(entity)
                } catch {
                    print("❌ Error al decodificar: \(error)")
                }

                self.entities = entities

                print(self.entities.count)
            }.store(in: &cancellables)
    }
}

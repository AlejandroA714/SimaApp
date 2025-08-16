import SwiftUI

struct InfoMapWindow: View {
    var entity: Entity?
    let onClear: () -> Void

    var body: some View {
        OverlayBackgroundView(optional: entity, onTapGesture: onClear) { e in
            VStack(alignment: .center, spacing: 8) {
                Text("ID: \(e.id)").font(.caption).bold()
                Text("Nivel: \(e.level)").font(.subheadline)
                ForEach(e.variables, id: \.name) { variable in
                    Text("\(variable.name): \(variable.value.value)")
                        .font(.caption)
                }
            }
            .frame(minWidth: UIScreen.main.bounds.width / 1.75,
                   minHeight: UIScreen.main.bounds.height / 6)
            .padding(15)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }.transition(.move(edge: .top).combined(with: .opacity))
            .animation(.easeOut(duration: 0.2), value: entity?.id)
    }
}

#Preview {
    InfoMapWindow(entity: Entity(id: "URN:NGSI-ld:RTUFS:002", type: "LORAWAN", level: 3, timeInstant: "14/07/2025", externalUri: nil, location: Location(lat: 13.715932, lng: -89.156336), color: "#f6d32d", variables: [Variable(name: "Humedad del Aire", value: StringOrNumber("65 %"), alert: Alert(name: "Media", color: "#f6d32d"))])) {}
}

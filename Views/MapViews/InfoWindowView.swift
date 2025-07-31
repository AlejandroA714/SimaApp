import SwiftUI

struct InfoWindowView: View {
    let entity: Entity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            VStack(alignment: .leading) {
                Text(entity.type)
                    .font(.headline)
                Text("Id: \(entity.id)")
                    .font(.subheadline)
            }

            Divider()

            // Body
            VStack(alignment: .leading, spacing: 4) {
                Text("Time: \(entity.timeInstant)")
                Text("Nivel: \(entity.level)")

                // Link si existe
                if let link = entity.externalUri {
                    Link("ENLACE", destination: URL(string: link)!)
                        .foregroundColor(.blue)
                }

                Divider()

                // Variables dinámicas
                ForEach(entity.variables.indices, id: \.self) { idx in
                    let v = entity.variables[idx]
                    HStack {
                        Text("\(v.name): \(v.value)")
                            .font(.footnote)
                        if let alert = v.alert {
                            Circle()
                                .fill(Color(alert.color))
                                .frame(width: 12, height: 12)
                                .overlay(TooltipView(text: alert.name))
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .shadow(radius: 3)
        .frame(maxWidth: 200)
    }
}

// Un tooltip sencillo SwiftUI
struct TooltipView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption2)
            .padding(4)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}

#Preview {
    InfoWindowView(entity: Entity(id: "aa", type: "dd", level: 1, timeInstant: "TimeInstant", externalUri: "externalURI", location: nil, color: "#ffffff", variables: []))
}

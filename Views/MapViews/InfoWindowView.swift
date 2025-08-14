import SwiftUI

struct InfoMapWindow: View {
    let entity: Entity?
    let onClear: () -> Void

    var body: some View {
        if let e = entity {
            VStack(alignment: .center) {
                HStack(spacing: 8) {
                    Text("ID: ").font(.caption).bold()
                    Text(e.id).font(.caption)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            onClear()
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                            .accessibilityLabel("Cerrar")
                    }
                    .buttonStyle(.plain)
                }
                .padding(8)
                Text("Nivel: \(e.level)").font(.subheadline)
                ForEach(e.variables, id: \.name) { variable in
                    Text("\(variable.name): \(variable.value.value)")
                        .font(.caption)
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(8)
            // .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
    }
}

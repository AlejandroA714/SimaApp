import SwiftUI

struct InfoMapWindow: View {
    @Binding var entity: Entity?
    @State private var localCopy: Entity?

    var body: some View {
        if let e = entity {
            VStack(alignment: .center) {
                HStack(spacing: 8) {
                    Text("ID: ").font(.caption).bold()
                    Text(e.id).font(.caption)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            entity = nil
                            localCopy = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                            .accessibilityLabel("Cerrar")
                    }
                    .buttonStyle(.plain)
                }
                Text("Nivel: \(e.level)").font(.subheadline)
                ForEach(e.variables, id: \.name) { variable in
                    Text("\(variable.name): \(variable.value.value)")
                        .font(.caption)
                }
            }.onChange(of: entity) { _, newValue in
                localCopy = newValue
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
    }
}

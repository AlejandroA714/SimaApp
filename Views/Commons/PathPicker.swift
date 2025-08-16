import SwiftUI

struct PathPicker: View {
    @Binding var selectedPath: String
    let path: [String]

    init(_ selectedPath: Binding<String>, _ path: [String]) {
        _selectedPath = selectedPath
        self.path = path
    }

    var body: some View {
        Picker("Path", selection: $selectedPath) {
            Text("/#").tag("/#")
            ForEach(path, id: \.self) { service in
                if service == selectedPath {
                    Text("/" + (service.components(separatedBy: "/").last ?? service))
                        .tag(service)
                } else {
                    Text(service).tag(service)
                }
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: 140, maxHeight: 40)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 3)
    }
}

#Preview {
    PathPicker(.constant("/#"), ["/SanSalvador/SSE", "SanSalvador/SSO", "SanSalvador/SSC", "DEN", "MARN", "SICA"])
}

import SwiftUI
import GoogleMaps

struct LoadingButton: View {
    @StateObject private var viewModel = ButtonViewModel()
    
    @EnvironmentObject var AppState: AppStateModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Botón con estados")
                .font(.title2)
            Picker("Tipo de mapa", selection: $AppState.mapType) {
                Text("Normal").tag(GMSMapViewType.normal)
                Text("Satélite").tag(GMSMapViewType.satellite)
                Text("Hibrido").tag(GMSMapViewType.hybrid)
                Text("Terraceria").tag(GMSMapViewType.terrain)
            }.onReceive(AppState.$mapType) { newValue in
                print("🌍 Cambio a \(newValue)")
            }
            Button(action: {
                viewModel.performAction()
            }) {
                if viewModel.isLoading {
                    ProgressView() // Indicador de carga
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Enviar")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(viewModel.isEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!viewModel.isEnabled) // Estado deshabilitado
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

#Preview {
    LoadingButton()
}

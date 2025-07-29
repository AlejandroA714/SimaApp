import SwiftUI

struct LoadingButton: View {
    
    @StateObject private var viewModel = ButtonViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
                 Text("Botón con estados")
                     .font(.title2)
                 
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

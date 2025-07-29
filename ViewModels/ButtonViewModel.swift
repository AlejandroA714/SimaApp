import SwiftUI

class ButtonViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isEnabled: Bool = true
    
    func performAction() {
        guard isEnabled else { return }
        
        isEnabled = false
        isLoading = true
        
        // Simula una operación asíncrona (API, etc.)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isLoading = false
            self.isEnabled = true
            let dd = KeyManager.GOOGLE_MAPS_API_KEY
            print(dd)
            print("✅ Acción completada")
        }
    }
}

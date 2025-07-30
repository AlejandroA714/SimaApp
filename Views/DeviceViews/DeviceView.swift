import SwiftUI

struct DeviceView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
                   List(viewModel.entities, id: \.id) { item in
                       Text(item.id)
                   }
                   .navigationTitle("NGSI Data")
                   .onAppear { viewModel.loadEntities() }
               }
    }
}

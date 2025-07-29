import SwiftUI


struct MapView: View {
    var body: some View {
        GoogleMapWrapper(lat: 13.796276494355524, lng: -89.19597387596932) // San Salvador
                    .edgesIgnoringSafeArea(.all)
    }
}

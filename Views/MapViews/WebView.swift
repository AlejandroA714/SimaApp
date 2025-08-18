import SwiftUI
import WebKit

struct WebView: View {
    let url: String

    var body: some View {
        WebViewWrapper(url: URL(string: url)!)
            .edgesIgnoringSafeArea(.all)
    }
}

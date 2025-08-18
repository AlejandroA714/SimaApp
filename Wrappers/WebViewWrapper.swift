import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

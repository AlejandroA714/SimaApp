import SwiftUI

struct OverlayBackgroundView<Content: View>: View {
    @Binding var showOverlay: Bool
    var onTapGesture: () -> Void
    let content: Content

    init(showOverlay: Binding<Bool> = .constant(true), onTapGesture: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        _showOverlay = showOverlay
        self.content = content()
        guard let ll = onTapGesture else {
            self.onTapGesture = {
                withAnimation(.spring()) { showOverlay.wrappedValue = false }
            }
            return
        }
        self.onTapGesture = ll
    }

    var body: some View {
        if showOverlay {
            ZStack {
                Color.white.opacity(0.01)
                    .ignoresSafeArea()
                    .onTapGesture { onTapGesture() }
                content
            }
        }
    }
}

#Preview {
    // OverlayBackgroundView(showOverlay: .constant(true))
}

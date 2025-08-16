import SwiftUI

struct OverlayBackgroundView<Content: View>: View {
    @Binding var showOverlay: Bool
    var onTapGesture: () -> Void
    let content: () -> Content

    private init(
        _ binding: Binding<Bool>,
        canMutate: Bool,
        onTapGesture: (() -> Void)?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _showOverlay = binding
        self.content = content
        if let onTap = onTapGesture {
            self.onTapGesture = onTap
        } else if canMutate {
            self.onTapGesture = {
                withAnimation(.spring()) { binding.wrappedValue = false }
            }
        } else {
            self.onTapGesture = {}
        }
    }

    init(
        showOverlay: Binding<Bool>,
        onTapGesture: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(showOverlay, canMutate: true, onTapGesture: onTapGesture, content: content)
    }

    init(
        showOverlay: Bool,
        onTapGesture: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(.constant(showOverlay), canMutate: false, onTapGesture: onTapGesture, content: content)
    }

    init<T>(
        optional value: T?,
        onTapGesture: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.init(showOverlay: value != nil, onTapGesture: onTapGesture) {
            content(value!)
        }
    }

    var body: some View {
        if showOverlay {
            ZStack {
                Color.white.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { onTapGesture() }
                content()
            }
        }
    }
}

#Preview {
    OverlayBackgroundView(showOverlay: .constant(true)) {
        VStack(alignment: .center, spacing: 8) {
            Text("ID: 1123").font(.caption).bold()
        }.frame(minWidth: UIScreen.main.bounds.width / 1.75,
                minHeight: UIScreen.main.bounds.height / 6)
            .padding(15)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

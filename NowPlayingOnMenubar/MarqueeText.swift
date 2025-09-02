import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: NSFont
    let spacing: CGFloat = 20
    
    @State private var textWidth: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                Text(text)
                    .font(Font(font))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .background(GeometryReader {
                        Color.clear.preference(key: WidthPreferenceKey.self, value: $0.size.width)
                    })
                
                // 2つ目も同じ設定
                Text(text)
                    .font(Font(font))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .offset(x: offset)
            .onPreferenceChange(WidthPreferenceKey.self) { width in
                self.textWidth = width
                self.startAnimation()
            }
            .onChange(of: text) {
                offset = 0
                startAnimation()
            }
        }
        .clipped()
    }
    
    private func startAnimation() {
        let totalWidth = textWidth + spacing
        let duration = Double(totalWidth) / 16 // 速度調整用
        offset = 0
        DispatchQueue.main.async {
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                offset = -totalWidth
            }
        }
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

import SwiftUI
import CoreText

struct TextEllipseStrokeView: View {
    let text: String
    let font: Font
    let duration: Double = 0.5
    
    @State var startTime: Date? = .now
    var isSelected: Bool
    
    init(text: String, font: Font = .myButton(20), isSelected: Bool) {
        self.text = text
        self.font = font
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let size = geometry.size
                let ellipsePath = createHandDrawnEllipsePath(for: size)

                if isSelected, startTime != nil {
                    TimelineView(.animation) { timeline in
                        let currentTime = timeline.date.timeIntervalSince(startTime!)
                        let progress = min(currentTime / duration, 1.0)

                        Canvas { context, _ in
                            let trimmedPath = ellipsePath.trimmedPath(from: 0, to: progress)
                            context.stroke(
                                trimmedPath,
                                with: .color(.strokeAcsent1),
                                lineWidth: 2.0
                            )
                        }
                    }
                }
            }


            Text(text)
                .font(font)
                .multilineTextAlignment(.center)
                .padding()
                .onChange(of: isSelected) { oldValue, newValue in
                    if newValue {
                        startTime = .now
                    }
                }
        }
    }

    private func createHandDrawnEllipsePath(for size: CGSize) -> Path {
        let boundingRect = CGRect(
            x: 0,
            y: 0,
            width: size.width,
            height: size.height
        ).insetBy(dx: 5, dy: 8)

        var path = Path()
        let steps = 20
        let noiseAmount: CGFloat = 2.0

        for i in 0..<steps { // Avoid closing the path
            let angle = CGFloat(i) / CGFloat(steps - 1) * 2 * .pi
            let x = boundingRect.midX + boundingRect.width / 2 * cos(angle)
            let y = boundingRect.midY + boundingRect.height / 2 * sin(angle)

            let randomX = x + CGFloat.random(in: -noiseAmount...noiseAmount)
            let randomY = y + CGFloat.random(in: -noiseAmount...noiseAmount)

            if i == 0 {
                path.move(to: CGPoint(x: randomX, y: randomY))
            } else {
                path.addLine(to: CGPoint(x: randomX, y: randomY))
            }
        }

        return path // Do not close the subpath
    }
}

//#Preview {
//    @Previewable @State var selectedElement: PickerElement = .new
//    SelectPickerView(selectedElement: $selectedElement)
//}

#Preview {
    HomeScreen()
}

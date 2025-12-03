//
//  TextToShape.swift
//  TimeToSow
//
//  Created by Nebo on 03.12.2025.
//

import SwiftUI


struct DrawText: View {
    
    var duration: Double = 3
    var font: UIFont = UIFont.myButton(70)
    
    @State var text = "DJn sad"
    
    @Binding var animate: Bool
    
    var body: some View {
        let textShape = TextToShape(value: text, font: font)
        VStack  {
            textShape
                .trim(from: 0, to: animate ? 1 : 0)
                .stroke(lineWidth: 1)
                .frame(height: 70)
                .animation(.easeInOut(duration: animate ? duration : 0), value: animate)
        }
    }
}


struct TextToShape: Shape {
    var value: String
    var font: UIFont
    
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
        
        font.drawGlyphs(for: value) { position, glyphPath in
            let transform = CGAffineTransform(translationX: position.x, y: position.y)
                .scaledBy(x: 1, y: -1)
            let newPath = Path(glyphPath).applying(transform)
            path.addPath(newPath)
        }
        let bounds = path.boundingRect
        let offsetX = rect.midX - bounds.midX
        let offsetY = rect.midY - bounds.midY
        let centerTransform = CGAffineTransform(translationX: offsetX, y: offsetY)
        
        return path.applying(centerTransform)
    }
}

extension UIFont {
    
    var ctFont: CTFont {
        let descriptor = self.fontDescriptor
        return CTFontCreateWithFontDescriptor(descriptor, 0, nil)
    }
    
    func toNSAttributedString(_ value: String) -> NSAttributedString {
        NSAttributedString(string: value, attributes: [.font: self])
    }
    
    func toSize(_ value: String) -> CGSize {
        NSString(string: value).size(withAttributes: [.font: self])
    }
    
    func drawGlyphs(for value: String, draw: @escaping (_ position: CGPoint, _ glyphPath: CGPath) -> ()) {
        let ctFont = self.ctFont
        let attributedString = self.toNSAttributedString(value)
        
        let line = CTLineCreateWithAttributedString(attributedString)
        let runs = CTLineGetGlyphRuns(line)
        
        for runIndex in 0..<CFArrayGetCount(runs) {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runs, runIndex), to: CTRun.self)
            let runCount = CTRunGetGlyphCount(run)
            
            for index in 0..<runCount {
                let range = CFRangeMake(index, 1)
                var glyph = CGGlyph()
                var position = CGPoint()
                
                CTRunGetGlyphs(run, range, &glyph)
                CTRunGetPositions(run, range, &position)
                
                if let glyphPath = CTFontCreatePathForGlyph(ctFont, glyph, nil) {
                    draw(position, glyphPath)
                }
                
            }
        }
    }
}

#Preview {
    @Previewable @State var isAnimate: Bool = false
    
    VStack {
        DrawText(animate: $isAnimate)
        Toggle("asd", isOn: $isAnimate)
    }
    
}

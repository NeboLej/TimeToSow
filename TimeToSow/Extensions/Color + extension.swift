//
//  Color + extension.swift
//  TimeToSow
//
//  Created by Nebo on 04.07.2025.
//

import SwiftUI

extension Color {
    
    static func averageTopRowColor(from image: UIImage?) -> Color {
        guard let image = image else { return .clear }
        guard let cgImage = image.cgImage else { return .clear }
        let width = cgImage.width
        
        let topRowRect = CGRect(x: 0, y: 0, width: width, height: 1)
        guard let croppedCGImage = cgImage.cropping(to: topRowRect) else { return .clear }
        
        let context = CGContext(data: nil,
                                width: width,
                                height: 1,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(croppedCGImage, in: CGRect(x: 0, y: 0, width: width, height: 1))
        guard let data = context?.data else { return .clear }
        
        let ptr = data.bindMemory(to: UInt8.self, capacity: width * 4)
        var totalR: UInt = 0
        var totalG: UInt = 0
        var totalB: UInt = 0
        
        for x in 0..<width {
            let offset = x * 4
            totalR += UInt(ptr[offset])
            totalG += UInt(ptr[offset + 1])
            totalB += UInt(ptr[offset + 2])
        }
        
        let pixelCount = UInt(width)
        let avgR = CGFloat(totalR) / CGFloat(pixelCount) / 255.0
        let avgG = CGFloat(totalG) / CGFloat(pixelCount) / 255.0
        let avgB = CGFloat(totalB) / CGFloat(pixelCount) / 255.0
        
        return Color(red: avgR, green: avgG, blue: avgB)
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

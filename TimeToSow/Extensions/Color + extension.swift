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
        let height = cgImage.height
        
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
}


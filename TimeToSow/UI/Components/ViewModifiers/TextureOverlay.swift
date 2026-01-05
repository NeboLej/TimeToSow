//
//  TextureOverlay.swift
//  TimeToSow
//
//  Created by Nebo on 05.12.2025.
//

import Foundation
import SwiftUI

struct TextureOverlay: ViewModifier {
    
    let opacity: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    Image(.texture1)
                        .resizable()
                        .scaledToFill()
                        .opacity(opacity)
                        .blendMode(.multiply)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .allowsHitTesting(false)
                }
            }
    }
}

#Preview {
    Rectangle()
        .foregroundStyle(.strokeAcsent2)
        .frame(width: 50, height: 250)
        .rainShimmer(if: true, height: 250)
}

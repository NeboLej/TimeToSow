//
//  View + Modifiers.swift
//  TimeToSow
//
//  Created by Nebo on 05.12.2025.
//

import SwiftUI

extension View {
    func textureOverlay(opacity: CGFloat = 0.7) -> some View {
        self.modifier(TextureOverlay(opacity: opacity))
    }
    
    func rainShimmer(if active: Bool, height: CGFloat) -> some View {
        self.modifier(RainEffectModifier(isActive: active, height: height))
    }
    
    func enableScrollViewSwipeActionModifier() -> some View {
        self.modifier(ScrollViewSwipeActionModifier())
    }
}

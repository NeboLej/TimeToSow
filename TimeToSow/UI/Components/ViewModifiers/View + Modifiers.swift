//
//  View + Modifiers.swift
//  TimeToSow
//
//  Created by Nebo on 05.12.2025.
//

import SwiftUI

extension View {
    func textureOverlay() -> some View {
        self.modifier(TextureOverlay())
    }
    
    func rainShimmer(if active: Bool, height: CGFloat) -> some View {
        self.modifier(RainEffectModifier(isActive: active, height: height))
    }
}

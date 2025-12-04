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
}

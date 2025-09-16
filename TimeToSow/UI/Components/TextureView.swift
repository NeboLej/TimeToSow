//
//  TextureView.swift
//  TimeToSow
//
//  Created by Nebo on 16.09.2025.
//

import SwiftUI

struct TextureView<Content>: View where Content : View {
    
    var content: Content
    var insets: EdgeInsets
    var color: Color
    var texture: Image?
    
    init(insets: EdgeInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12),
         texture: Image = Image("Texture1"),
         color: Color = .white,
          @ViewBuilder content: () -> Content) {
        self.content = content()
        self.insets = insets
        self.color = color
        self.texture = texture
    }
    
    var body: some View {

        VStack {
            content
                .padding(insets)
        }.background {
            ZStack {
                color
                texture?
                    .blendMode(.multiply)
                    .opacity(0.4)
            }
        }
        .clipped()
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

#Preview {
    TextureView {
        HStack(spacing: 20) {
            VStack {
                Text("Automatic Pinning: Configure automatic pinning in Xcode > Settings > Navigation > Pin Tabs. Options include When Tab Is Created or When Tab Is Edited. Manual Pinning: Click the pin icon on an editor tab or use View > Pin Editor Tab to manually pin a tab. Unpin using the same methods.")
            }
            Text("Hello").font(.headline.weight(.heavy))
            Circle().frame(width: 20, height: 20)
            
        }
    }
}

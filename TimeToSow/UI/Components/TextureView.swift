//
//  TextureView.swift
//  TimeToSow
//
//  Created by Nebo on 16.09.2025.
//

import SwiftUI

struct TextureView<Content>: View where Content : View {
    
    private var content: Content
    private var insets: EdgeInsets
    private var color: Color
    private var texture: Image?
    private var cornerRadius: CGFloat
    private var textureOpacity: CGFloat
    
    init(insets: EdgeInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12),
         texture: Image = Image("texture_1"),
         textureOpacity: CGFloat = 0.4,
         color: Color = .white,
         cornerRadius: CGFloat = 0,
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.insets = insets
        self.color = color
        self.texture = texture
        self.textureOpacity = textureOpacity
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        content
            .padding(insets)
            .background {
                ZStack {
                    color
                    texture?
                        .resizable()
                        .opacity(textureOpacity)
                        .blendMode(.multiply)
                    
                }.allowsHitTesting(false)
            }
            .cornerRadius(cornerRadius, corners: .allCorners)
            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 4)
    }
}

#Preview {
    ScrollView {
        TextureButton(label: "Start",
                      color: .green,
                      icon: Image(.deleteAnimation2)) {
            
        }
        TagView(tag: Tag(name: "play in basketball", color: "#D17474"))
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
}


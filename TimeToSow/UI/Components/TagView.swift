//
//  TagView.swift
//  TimeToSow
//
//  Created by Nebo on 17.09.2025.
//

import SwiftUI

struct TagView: View {
    
    @State var tag: Tag
    
    var body: some View {
        let color = Color(hex: tag.color)
        
        TextureView(insets: .init(top: 4, leading: 8, bottom: 4, trailing: 8),
                    texture: Image(.mediumTexture1),
                    textureOpacity: 1,
                    color: color.opacity(0.4),
                    cornerRadius: 30) {
            HStack(spacing: 6) {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(color)
                Text(tag.name)
                    .font(.myTitle(13))
                
            }
        }.overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(style: .init(lineWidth: 0.5))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    TagView(tag: Tag(name: "play in basketball", color: "#D17474"))
}


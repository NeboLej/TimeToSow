//
//  FlatShadow.swift
//  TimeToSow
//
//  Created by Nebo on 27.06.2025.
//

import Foundation
import SwiftUI


extension View {
    func flatShadow(
        color: Color = .black,
        offset: CGSize = CGSize(width: 2, height: -6),
        blur: CGFloat = 3,
        scaleY: CGFloat = 0.8,
        scaleX: CGFloat = 0.7,
        distanceToLight: CGFloat
    ) -> some View {
        self
            .overlay(
                ZStack {
                    self
                        .rotationEffect(Angle.degrees(abs(distanceToLight)/10.0 > 10 ? abs(distanceToLight)/10.0 : 10), anchor: .bottom)
                        .scaleEffect(x: scaleX, y: 300/abs(distanceToLight) > 0.9 ? 0.9 : 300/abs(distanceToLight) , anchor: .bottom)
                        .blur(radius: blur)
                        .offset(offset)
                        .colorMultiply(color.opacity(CGFloat(200)/(distanceToLight + 150)))
                        .blendMode(.multiply)
                    self
                })
    }
}

#Preview {
    HomeScreen()
}

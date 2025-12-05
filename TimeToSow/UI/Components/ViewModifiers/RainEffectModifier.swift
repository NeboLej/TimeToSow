//
//  RainEffectModifier.swift
//  TimeToSow
//
//  Created by Nebo on 05.12.2025.
//

import Foundation

import SwiftUI

struct RainEffectModifier: ViewModifier {
    let isActive: Bool
    let height: CGFloat
    
    let dropCount = 35
    let fallSpeedRange: ClosedRange<Double> = 0.8...1.8
    let xWiggleAmplitude: CGFloat = 6
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isActive {
                    Circle()
                        .foregroundStyle(.blue)
                        .frame(width: 80, height: 80)
                        .zIndex(10)
                        .offset(x: 0, y: -100)
                    ForEach(0..<dropCount, id: \.self) { i in
                        RainDrop(
                            id: i,
                            contentHeight: height,
                            speed: .random(in: fallSpeedRange),
                            xWiggleAmplitude: xWiggleAmplitude
                        )
                    }
                }
            }
    }
}

struct RainDrop: View {
    let id: Int
    var contentHeight: CGFloat
    let dropWidth: CGFloat = 2
    let dropHeight: CGFloat = 14
    let speed: Double
    let xWiggleAmplitude: CGFloat
    
    @State private var startY: CGFloat = 0
    @State private var xOffset: CGFloat = .random(in: -25...25)
    @State private var fallProgress: CGFloat = 0
    
    var body: some View {
        let duration = speed
        
        Rectangle()
            .fill(Color.blue.opacity(0.6))
            .frame(width: dropWidth, height: dropHeight)
            .cornerRadius(dropWidth / 2)
            .scaleEffect(1 - (fallProgress * 0.4))
            .opacity(1.0 - (fallProgress * 0.9))
            .offset(
                x: xOffset + sin(fallProgress * 10) * xWiggleAmplitude,
                y:  -100 + fallProgress * (contentHeight * 0.5 + 100)
            )
            .onAppear {
                fallProgress = 0
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    fallProgress = 1
                }
            }
    }
}

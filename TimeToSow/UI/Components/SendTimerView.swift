//
//  SendTimerView.swift
//  TimeToSow
//
//  Created by Nebo on 05.01.2026.
//

import SwiftUI

struct SendTimerView: View {
    
    var progress: CGFloat
    
    var body: some View {
        
        ZStack {
            Group {
                Image(.sendTimerWater)
                    .resizable()
                    .overlay(alignment: .bottom) {
                        GeometryReader { proxy in
                            Rectangle()
                                .background(.black)
                                .blendMode(.destinationOut)
                                .frame(height: (proxy.size.height) * progress * 0.45)
                                .offset(y: proxy.size.height * 0.08)
                            
                            if progress < 1 {
                                rainView()
                                    .frame(height: proxy.size.height * 0.4)
                                    .frame(width: proxy.size.width * 0.8)
                                    .offset(x: proxy.size.width * 0.1, y: proxy.size.height * 0.53)
                            }
                        }
                    }
                    .compositingGroup()
                
                Image(.sendTimerDert)
                    .resizable()
                    .zIndex(2)
                
                Image(.sendTimerPlant1)
                    .resizable()
                
                Image(.sendTimerPlant2)
                    .resizable()
                    .opacity(progress > 0.3 ? 1 : 0)
                    .animation(.default, value: progress)
                
                Image(.sendTimerPlant3)
                    .resizable()
                    .opacity(progress > 0.6 ? 1 : 0)
                    .animation(.default, value: progress)
                
                Image(.sendTimerGreen)
                    .resizable()
                    .zIndex(progress < 0.7 ? 1 : 3)
                    .animation(.default, value: progress)
                
                Image(.sendTimerGlass)
                    .resizable()
            }
            .scaledToFit()

            
        }
    }
    
    @ViewBuilder
    private func rainView() -> some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<12, id: \.self) { _ in
                    SendRainDrop(width: geo.size.width, height: geo.size.height)
                }
            }
            .clipped()
        }
    }
}

fileprivate struct SendRainDrop: View {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        
        horizontalDrift = CGFloat.random(in: -width/2...width/2)
    }

    @State private var y: CGFloat = -50
    @State private var xOffset: CGFloat = 0

    private let startX = CGFloat.random(in: 0...1)
    private let horizontalDrift: CGFloat
    private let speed = Double.random(in: 1.8...3.2)
    private let delay = Double.random(in: 0...2)

    var body: some View {
        Capsule()
            .fill(Color(hex: "#8CBEFF"))
            .frame(width: 3, height: 6)
            .position(x: 0.5 * width + xOffset, y: y)
            .onAppear {
                y = -20
                xOffset = 0

                withAnimation(
                    .linear(duration: speed)
                    .delay(delay)
                    .repeatForever(autoreverses: false)
                ) {
                    y = height + 40
                    xOffset = horizontalDrift
                }
            }
    }
}


#Preview {
    PreviewWithTimer(duration: 120)
}

private struct PreviewWithTimer: View {
    let duration: TimeInterval
    private let startDate = Date()

    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = context.date.timeIntervalSince(startDate)
            let progress = min(max(elapsed / duration, 0), 1)

            HStack(alignment: .bottom) {
                SendTimerView(progress: progress)
                    .frame(width: 200)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.1))
        }
    }
}

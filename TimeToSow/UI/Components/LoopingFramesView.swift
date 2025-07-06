//
//  LoopingFramesView.swift
//  TimeToSow
//
//  Created by Nebo on 04.07.2025.
//

import SwiftUI
import Combine

struct LoopingFramesView: View {

    @State var frames: [String]
    @State var speed: CGFloat
    
    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var frameIndex = 0
    
    init(frames: [String], speed: CGFloat) {
        self.frames = frames
        self.speed = speed
        timer = Timer.publish(every: speed, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        Image(frames[frameIndex])
            .resizable()
            .scaledToFit()
//            .animation(.linear(duration: speed * 0.9), value: frameIndex)
            .onReceive(timer) { _ in
                frameIndex = (frameIndex + 1) % frames.count
            }
    }
}


#Preview {
    LoopingFramesView(frames: ["updateAnimation1", "updateAnimation2", "updateAnimation3", "updateAnimation4"], speed: 0.4)
}

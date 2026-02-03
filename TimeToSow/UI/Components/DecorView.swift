//
//  DecorView.swift
//  TimeToSow
//
//  Created by Nebo on 23.01.2026.
//

import SwiftUI

struct DecorView: View {
    
    @State private var decor: Decor
    @State private var positionDelegate: PositionDecorDelegate
    
    @State private var accumulatedX: CGFloat
    @State private var accumulatedY: CGFloat
    @State private var offsetX: CGFloat
    @State private var offsetY: CGFloat
    
    @State private var isDragging = false
    
    init(decor: Decor, positionDelegate: PositionDecorDelegate) {
        self.decor = decor
        self.offsetX = decor.offsetX
        self.offsetY = decor.offsetY
        self.accumulatedX = decor.offsetX
        self.accumulatedY = decor.offsetY
        self.positionDelegate = positionDelegate
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            DecorTypePreview(decorType: decor.decorType, isDragging: $isDragging)
        }
        .animation(isDragging ? nil : .easeInOut(duration: 1), value: offsetX)
        .zIndex(isDragging ? 10000 : abs(offsetY))
        .offset(x: offsetX, y: offsetY)
        .onAppear {
            decorFall()
        }
        .gesture(DragGesture()
            .onChanged { value in
                let newOffsetX = value.translation.width + self.accumulatedX
                
                if !isDragging {
                    isDragging = true
                    Vibration.light.vibrate()
                    positionDelegate.beganDecorToChangePosition()
                }
                
                if newOffsetX < 0 {
                    offsetX = 0
                } else if newOffsetX > positionDelegate.roomViewWidth - decor.decorType.width {
                    offsetX = positionDelegate.roomViewWidth - decor.decorType.width
                } else {
                    offsetX = newOffsetX
                }
                
                offsetY = value.translation.height + self.accumulatedY
            }
            .onEnded { value in
                isDragging = false
                decorFall()
                
                self.accumulatedX = offsetX
                self.accumulatedY = offsetY
            }
        )
    }
    
    func decorFall() {
        let point = positionDelegate.getPositionOfDecorInFall(decor: decor, x: offsetX, y: offsetY)
        if point.x == offsetX && point.y == offsetY { return }
        
        withAnimation(.easeIn) {
            offsetY = point.y
            offsetX = point.x
        } completion: {
            accumulatedX = offsetX
            accumulatedY = offsetY
            Vibration.medium.vibrate()
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .home)
}

//
//  DecorView.swift
//  TimeToSow
//
//  Created by Nebo on 23.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct DecorView: View {
    
    @State private var decor: Decor
    @State private var positionDelegate: PositionDecorDelegate
    
    @State private var accumulatedX: CGFloat
    @State private var accumulatedY: CGFloat
    @State private var offsetX: CGFloat
    @State private var offsetY: CGFloat
    
    @State private var isDragging = false
    @State private var isAnimating = false
    
    init(decor: Decor, positionDelegate: PositionDecorDelegate) {
        self.decor = decor
//        self.isSelected = plant.isSelected
        self.offsetX = decor.positon.x
        self.offsetY = decor.positon.y
        self.accumulatedX = decor.positon.x
        self.accumulatedY = decor.positon.y
        self.positionDelegate = positionDelegate
    }
    
    var body: some View {
        VStack {
            let name = decor.resourceName + (decor.animationOptions != nil ? ".gif" : ".png")
            
            if name.contains(".gif") {
                AnimatedImage(name: name, bundle: .main, isAnimating: $isAnimating)
                    .resizable()
                    .customLoopCount(decor.animationOptions?.repeatCount ?? 1)
                    .scaledToFit()
                    .frame(height: decor.height)
                    .offset(x: decor.positon.x, y: decor.positon.y)
                    .onTapGesture {
                        isAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + (decor.animationOptions?.duration ?? 2)) {
                            isAnimating = false
                        }
                    }
            } else {
                Image.file(name)
                    .resizable()
                    .scaledToFit()
                    .frame(height: decor.height)
                    .offset(x: decor.positon.x, y: decor.positon.y)
            }
        }
        .animation(.easeInOut(duration: 0.1), value: offsetX)
        .animation(.easeIn(duration: isDragging ? 0 : 0.4), value: offsetY)
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
                } else if newOffsetX > positionDelegate.roomViewWidth - decor.width {
                    offsetX = positionDelegate.roomViewWidth - decor.width
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
//            isShowDust = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                isShowDust = false
//            }
        }
    }
}

#Preview {
    VStack {
        screenBuilderMock.getComponent(type: .roomView(id: nil))
        Spacer()
    }.ignoresSafeArea()
}


//#Preview {
//    DecorView(decor: Decor(id: UUID(), name: "Лошадка", locationType: .stand,
//                           animationOptions: AnimationOptions(duration: 1, repeatCount: 2, timeRepetition: 30),
//                           resourceName: "decor1", positon: .zero, height: 40, width: 40))
//}

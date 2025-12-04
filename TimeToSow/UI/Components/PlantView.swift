//
//  PlantView.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct PlantView: View {
    
    @State private var plant: Plant
    @State private var accumulatedX: CGFloat
    @State private var accumulatedY: CGFloat
    @State private var offsetX: CGFloat
    @State private var offsetY: CGFloat
    @State private var positionDelegate: PositionPlantDelegate
    
    @State private var rotationAngle: Double = 0.0
    @State private var isDragging = false
    @State var isShowDust = false
    @State var menuIsShow = false
    
    init(plant: Plant, positionDelegate: PositionPlantDelegate) {
        self.plant = plant
        
        self.offsetX = plant.offsetX
        self.offsetY = plant.offsetY
        self.accumulatedX = plant.offsetX
        self.accumulatedY = plant.offsetY
        self.positionDelegate = positionDelegate
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image(plant.seed.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.seed.height))
                .offset(x: (plant.seed.rootCoordinateCoef?.x ?? 0) * CGFloat(plant.seed.height)
                        + (plant.pot.anchorPointCoefficient?.x ?? 0) * CGFloat(plant.pot.height),
                        y: (plant.seed.rootCoordinateCoef?.y ?? 0) * CGFloat(plant.seed.height)
                        + (plant.pot.anchorPointCoefficient?.y ?? 0) * CGFloat(plant.pot.height))
                .zIndex(10)
                .flatShadow(distanceToLight: offsetY)
            
            ZStack {
                Image(plant.pot.image)
                    .resizable()
                    .scaledToFit()
                    .flatShadow(distanceToLight: offsetY)
                    .overlay {
                        plantMenu()
                    }
                Image(plant.pot.image)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .clipShape(AngledShape())
                    .foregroundStyle(.black.opacity(0.2))

                
            }
            .frame(height: CGFloat(plant.pot.height))
            
            if isShowDust {
                DustView(width: CGFloat(plant.pot.height))
            }
        }
        
        .rotationEffect(.degrees(rotationAngle), anchor: .center)
        .offset(x: offsetX, y: offsetY)
        .zIndex(abs(offsetY))
        .onAppear {
            plantsFall()
        }
        .gesture(LongPressGesture(minimumDuration: 0.7)
            .onChanged { _ in
                print("123123")
            }
            .onEnded { _ in
                Vibration.light.vibrate()
//                positionDelegate.longPressed(plant: plant)
                withAnimation {
                    menuIsShow.toggle()
                }
            }
        )
        
        .gesture(DragGesture()
            .onChanged { value in
                let newOffsetX = value.translation.width + self.accumulatedX
                
                if !isDragging {
                    isDragging = true
                    Vibration.light.vibrate()
                    positionDelegate.beganToChangePosition()
                    startShaking()
                }
                
                if newOffsetX < 0 {
                    offsetX = 0
                } else if newOffsetX > positionDelegate.roomViewWidth - plant.pot.width {
                    offsetX = positionDelegate.roomViewWidth - plant.pot.width
                } else {
                    offsetX = newOffsetX
                }
                
                offsetY = value.translation.height + self.accumulatedY
            }
            .onEnded { value in
                stopShaking()
                plantsFall()
                
                self.accumulatedX = offsetX
                self.accumulatedY = offsetY
            }
        )
    }
    
    @ViewBuilder
    func plantMenu() -> some View {
        ZStack {
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.red)
                .offset(y: menuIsShow ? Double(plant.pot.height / 2) + 20 : 0)
            
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.blue)
                .offset(y: menuIsShow ? Double(plant.pot.height / 2) + 23 : 0)
                .rotationEffect(.degrees(45))
            
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.green)
                .offset(y: menuIsShow ? Double(plant.pot.height / 2) + 23 : 0)
                .rotationEffect(.degrees(-45))
        }.opacity(menuIsShow ? 1 : 0)
    }
    
    private func plantsFall() {
        let point = positionDelegate.getPositionOfPlantInFall(plant: plant, x: offsetX, y: offsetY)
        if point.x == offsetX && point.y == offsetY { return }
        
        withAnimation(.easeIn) {
            offsetY = point.y
            offsetX = point.x
        } completion: {
            accumulatedX = offsetX
            accumulatedY = offsetY
            Vibration.medium.vibrate()
            isShowDust = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShowDust = false
            }
        }
    }
    
    
    private func startShaking() {
        withAnimation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            rotationAngle = 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if isDragging {
                withAnimation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                    rotationAngle = -5
                }
            }
        }
    }
    
    private func stopShaking() {
        isDragging = false
        withAnimation(.easeOut(duration: 0.4)) {
            rotationAngle = 0.0
        }
    }
}

#Preview {
    HomeScreen()
}

struct AngledShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX * 1.5, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX * 1.2, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

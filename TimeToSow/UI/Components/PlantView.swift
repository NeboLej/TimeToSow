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
    
    init(plant: Plant, positionDelegate: PositionPlantDelegate) {
        self.plant = plant
        let startPosition = positionDelegate.getPositionPlant(plant: plant)
        self.offsetX = startPosition.x
        self.offsetY = startPosition.y
        self.accumulatedX = startPosition.x
        self.accumulatedY = startPosition.y
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
            
            ZStack {
                Image(plant.pot.image)
                    .resizable()
                    .scaledToFit()
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
        .flatShadow(distanceToLight: offsetY)
        .rotationEffect(.degrees(rotationAngle), anchor: .center)
        .offset(x: offsetX, y: offsetY)
        .onChange(of: plant) { oldValue, newValue in
            plantsFall()
        }
        .onAppear {
            plantsFall()
        }
        .gesture(DragGesture()
            .onChanged { value in
                let newOffsetX = value.translation.width + self.accumulatedX
                
                if !isDragging {
                    isDragging = true
                    Vibration.light.vibrate()
                    startShaking()
                }
                
                if newOffsetX < 0 {
                    offsetX = 0
                } else if newOffsetX > positionDelegate.width - plant.pot.width {
                    offsetX = positionDelegate.width - plant.pot.width
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
    
    private func plantsFall() {
        withAnimation(.easeIn) {
            let point = positionDelegate.getPositionOfPlantInFall(plant: plant, x: offsetX, y: offsetY)
            offsetY = point.y
            offsetX = point.x
        } completion: {
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

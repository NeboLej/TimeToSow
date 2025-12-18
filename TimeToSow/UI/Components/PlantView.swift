//
//  PlantView.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct PlantView: View {
    
    @State private var plant: PlantViewState
    private var isSelected: Bool
    @State private var accumulatedX: CGFloat
    @State private var accumulatedY: CGFloat
    @State private var offsetX: CGFloat
    @State private var offsetY: CGFloat
    @State private var positionDelegate: PositionPlantDelegate
    
    @State private var rotationAngle: Double = 0.0
    @State private var isDragging = false
    @State var isShowDust = false
    
    init(plant: PlantViewState, positionDelegate: PositionPlantDelegate) {
        self.plant = plant
        self.isSelected = plant.isSelected
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
        .rainShimmer(if: isSelected, height: CGFloat(plant.pot.height + plant.seed.height))
        .rotationEffect(.degrees(isDragging ? 6 : 0), anchor: .center)
        .animation(
            isDragging
                ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
                : .easeOut(duration: 0.5),
            value: isDragging
        )
        .animation(.easeInOut(duration: 0.1), value: offsetX)
        .animation(.easeIn(duration: isDragging ? 0 : 0.4), value: offsetY)
        .offset(x: offsetX, y: offsetY)
        .zIndex(abs(offsetY))
        .onAppear {
            plantsFall()
        }
        .onTapGesture(perform: {
            Vibration.light.vibrate()
            positionDelegate.selected(plant: plant.original)
        })
        .gesture(DragGesture()
            .onChanged { value in
                let newOffsetX = value.translation.width + self.accumulatedX
                
                if !isDragging {
                    isDragging = true
                    Vibration.light.vibrate()
                    positionDelegate.beganToChangePosition()
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
                isDragging = false
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
                .offset(y: isSelected ? Double(plant.pot.height / 2) + 20 : 0)
            
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.blue)
                .offset(y: isSelected ? Double(plant.pot.height / 2) + 23 : 0)
                .rotationEffect(.degrees(45))
            
            Circle()
                .frame(width: 18, height: 18)
                .foregroundStyle(.green)
                .offset(y: isSelected ? Double(plant.pot.height / 2) + 23 : 0)
                .rotationEffect(.degrees(-45))
        }.opacity(isSelected ? 1 : 0)
    }
    
    private func plantsFall() {
        let point = positionDelegate.getPositionOfPlantInFall(plant: plant.original, x: offsetX, y: offsetY)
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
}

#Preview {
    screenBuilderMock.getScreen(type: .home)
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

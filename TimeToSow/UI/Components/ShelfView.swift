//
//  ShelfView.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import UIKit

struct PlantView: View {
    
    @State var plant: Plant
    @State private var accumulatedX: CGFloat
    @State private var accumulatedY: CGFloat
    @State var offsetX: CGFloat
    @State var offsetY: CGFloat
    @State var positionDelegate: PositionPlantDelegate
    
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
                .frame(height: CGFloat(plant.seed.width))
            Image(plant.pot.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.pot.width))
        }
        .offset(x: offsetX, y: offsetY)
        .gesture(DragGesture()
            .onChanged { value in
                let newOffsetX = value.translation.width + self.accumulatedX

                if newOffsetX < 0 {
                    offsetX = 0
                } else if newOffsetX > positionDelegate.width - CGFloat(plant.pot.width) {
                    offsetX = positionDelegate.width - CGFloat(plant.pot.width)
                } else {
                    offsetX = newOffsetX
                }
                
                offsetY = value.translation.height + self.accumulatedY
            }
            .onEnded { value in
                withAnimation(.easeIn) {
                    let point = positionDelegate.getPositionOfPlantInFall(plant: plant, x: offsetX, y: offsetY)
                    offsetY = point.y
                    offsetX = point.x
                }
                self.accumulatedX = offsetX
                self.accumulatedY = offsetY
            }
        )
    }
}

struct ShelfView: View {
    
    @State var shelf: Shelf
    @State var height: CGFloat = 400
    @State var width: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
                Image(shelf.type.image)
                    .resizable()
                plants()
                //для тестирования позиций полок
                //shelfsTest()
                
            }
        }
        .frame(height: height)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            width = newValue.width
        }
    }
    
    @ViewBuilder
    func plants() -> some View {
        ForEach(shelf.plants, id: \.self) {
            PlantView(plant: $0, positionDelegate: self)
        }
    }
    
    @ViewBuilder
    func shelfsTest() -> some View {
        ForEach(shelf.type.shelfPositions,  id: \.self) {
            Rectangle()
                .fill(.red)
                .frame(height: 12)
                .offset(y: $0.coefOffsetY * height)
                .padding(.leading, $0.paddingLeading)
                .padding(.trailing, $0.paddingTrailing)
                .opacity(0.1)
        }
    }
}


extension ShelfView: PositionPlantDelegate {
    
    func getPositionPlant(plant: Plant) -> CGPoint {
        CGPoint(x: plant.offsetX, y: getOffsetY(line: plant.line) - CGFloat(plant.pot.width) - CGFloat(plant.seed.width) + 1)
    }
    
    func getPositionOfPlantInFall2(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        let y = y + CGFloat(plant.pot.width) + CGFloat(plant.seed.width)
        let shelfsY = shelf.type.shelfPositions.map { shelfPosition in
            shelfPosition.coefOffsetY * height
        }.sorted { $0 < $1 }
        let result = shelfsY.first(where: { $0 > y } ) ?? shelfsY.last ?? 0
        
        return CGPoint(x: x, y: result - CGFloat(plant.pot.width) - CGFloat(plant.seed.width) + 1)
    }
    
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        let y = y + CGFloat(plant.pot.width) + CGFloat(plant.seed.width)
        
        let shelfs = shelf.type.shelfPositions.sorted { $0.coefOffsetY < $1.coefOffsetY }
        
        for shelf in shelfs {
            if shelf.coefOffsetY * height >= y {
                if x >= shelf.paddingLeading - CGFloat(plant.pot.width) / 2 && x <= width - shelf.paddingTrailing - CGFloat(plant.pot.width) / 2 {
                    return CGPoint(x: x, y: shelf.coefOffsetY * height - CGFloat(plant.pot.width) - CGFloat(plant.seed.width) + 1)
                }
            }
        }
        
        return CGPoint(x: x, y: (shelfs.last?.coefOffsetY ?? 0) * height - CGFloat(plant.pot.width) - CGFloat(plant.seed.width) + 1)
    }
    
    private func getOffsetY(line: Int) -> CGFloat {
        shelf.type.shelfPositions[line].coefOffsetY * height
    }
}

//#Preview {
//    ShelfView()
//}

#Preview {
    HomeScreen()
}

protocol PositionPlantDelegate {
    var width: CGFloat { get }
    func getPositionPlant(plant: Plant) -> CGPoint
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint
}

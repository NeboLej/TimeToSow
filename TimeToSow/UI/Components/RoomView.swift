//
//  RoomView.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import UIKit

protocol PositionPlantDelegate {
    var width: CGFloat { get }
    func getPositionPlant(plant: Plant) -> CGPoint
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint
}

struct RoomView: View {
    
    @Binding var room: UserMonthRoom
    @State var height: CGFloat = 400
    @State var width: CGFloat = 0
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Image(room.roomType.image)
                    .resizable()
                Image(room.shelfType.image)
                    .resizable()
                plants()
                    .id(room)
               
//                для тестирования позиций полок
//                shelfsTest()
                
            }
//            window()
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
        ForEach(room.plants, id: \.self) {
            PlantView(plant: $0, positionDelegate: self)
                .zIndex(getOffsetY(line: $0.line))
        }
    }
    
//    @ViewBuilder
//    func window() -> some View {
//        HStack(spacing: 15) {
//            Rectangle()
//                .scale(x: 0.8, y: 1, anchor: .trailing)
//            
//            VStack(spacing: 10) {
//                Rectangle()
//                    .frame(height: 70)
//                Rectangle()
//                
//            }
//        }
//        .frame(width: 180, height: 200)
//        .foregroundStyle(.white.opacity(0.08))
//        .blendMode(.plusLighter)
//            .transformEffect(CGAffineTransform(a: 1, b: 0, c: -0.2, d: 1, tx: 0, ty: 0))
//            .allowsHitTesting(false)
//            .offset(x: -100, y: -15)
//    }
    
    @ViewBuilder
    func shelfsTest() -> some View {
        ForEach(room.shelfType.shelfPositions,  id: \.self) {
            Rectangle()
                .fill(.red)
                .frame(height: 12)
                .offset(y: $0.coefOffsetY * height)
                .padding(.leading, $0.paddingLeading)
                .padding(.trailing, $0.paddingTrailing)
                .opacity(0.4)
        }
    }
}


extension RoomView: PositionPlantDelegate {
    
    func getPositionPlant(plant: Plant) -> CGPoint {
        CGPoint(x: plant.offsetX, y: getOffsetY(line: plant.line) - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
    }
    
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        let y = y + CGFloat(plant.pot.height) + CGFloat(plant.seed.height)
        let deltaX = [plant.pot.width, plant.seed.width].max()! / 2
        print(deltaX)
        let shelfs = room.shelfType.shelfPositions.sorted { $0.coefOffsetY < $1.coefOffsetY }
        
        for shelf in shelfs {
            if shelf.coefOffsetY * height >= y {
                if x + deltaX >= shelf.paddingLeading  && x + deltaX <= width - shelf.paddingTrailing {
                    return CGPoint(x: x, y: shelf.coefOffsetY * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
                }
            }
        }
        
        return CGPoint(x: x, y: (shelfs.last?.coefOffsetY ?? 1) * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
    }
    
    private func getOffsetY(line: Int) -> CGFloat {
        let coefOffsetY = room.shelfType.shelfPositions[safe: line]?.coefOffsetY ?? room.shelfType.shelfPositions.last?.coefOffsetY ?? 1
        return coefOffsetY * height
    }
}

//#Preview {
//    ShelfView()
//}

#Preview {
    HomeScreen()
}

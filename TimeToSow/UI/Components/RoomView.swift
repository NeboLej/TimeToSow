//
//  RoomView.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import UIKit

protocol PositionPlantDelegate {
    var roomViewWidth: CGFloat { get }
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint
    func beganToChangePosition()
}

protocol PlantEditorDelegate {
    func editPositionPlant(plant: Plant, newPosition: CGPoint)
    func positionFixedOutsideTheRoom(plant: Plant, newPosition: CGPoint)
    func beganToChangePosition()
}

struct RoomView: View {
    
    @Binding var room: UserMonthRoom
    @State var height: CGFloat = 400
    @State var roomViewWidth: CGFloat = 0
    @State var plantEditorDelegate: PlantEditorDelegate?
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { proxy in
                Image(room.roomType.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Image(room.shelfType.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                plants()
                
                    .id(room.shelfType.id)
//                для тестирования позиций полок
//                shelfsTest()
                
            }
        }
        .frame(height: height)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            roomViewWidth = newValue.width
        }
    }
    
    @ViewBuilder
    func plants() -> some View {
        ForEach(room.plants, id: \.id) {
            PlantView(plant: $0, positionDelegate: self)
        }
    }
    
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
    
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        let result: CGPoint
        let y = y + CGFloat(plant.pot.height) + CGFloat(plant.seed.height)
        let deltaX = [plant.pot.width, plant.seed.width].max()! / 2
        
        defer {
            plantEditorDelegate?.editPositionPlant(plant: plant, newPosition: result)
        }
        
        let shelfs = room.shelfType.shelfPositions.sorted { $0.coefOffsetY < $1.coefOffsetY }
        
        for shelf in shelfs {
            if shelf.coefOffsetY * height >= y {
                if x + deltaX >= shelf.paddingLeading  && x + deltaX <= roomViewWidth - shelf.paddingTrailing {
                    result = CGPoint(x: x, y: shelf.coefOffsetY * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
                    return result
                }
            }
        }
        plantEditorDelegate?.positionFixedOutsideTheRoom(plant: plant, newPosition: CGPoint(x: x, y: y))
        
        result = CGPoint(x: x, y: (shelfs.last?.coefOffsetY ?? 1) * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
        return result
    }
    
    func beganToChangePosition() {
        plantEditorDelegate?.beganToChangePosition()
    }
}

//#Preview {
//    ShelfView()
//}

#Preview {
    HomeScreen()
}

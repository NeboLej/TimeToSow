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
    func selectPlant(_ plant: Plant)
    func detailPlant(_ plant: Plant)
}

struct RoomView: View {
    
    @State var height: CGFloat = 400
    @State var roomViewWidth: CGFloat = 0
    
    var store: RoomFeatureStore
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Image(store.state.roomType.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Image(store.state.shelfType.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                plants()
                    .id(store.state.shelfType)
            }
        }
        .frame(height: height)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            roomViewWidth = newValue.width
            height = newValue.width
        }
        .onTapGesture {
            store.send(.roomTapped)
        }
    }
    
    @ViewBuilder
    func plants() -> some View {
        ForEach(store.state.plants, id: \.id) {
            PlantView(plant: $0, positionDelegate: self)
        }
    }
    
    @ViewBuilder
    func shelfsTest() -> some View {
        ForEach(store.state.shelfType.shelfPositions,  id: \.self) {
            Rectangle()
                .fill(.red)
                .frame(height: 12)
                .offset(y: $0.coefOffsetY * height)
                .padding(.leading, $0.paddingLeading * (height / 400))
                .padding(.trailing, $0.paddingTrailing * (height / 400))
                .opacity(0.4)
        }
    }
}

extension RoomView: PositionPlantDelegate {
    
    func selectPlant(_ plant: Plant) {
        store.send(.selectPlant(plant))
    }
    
    func detailPlant(_ plant: Plant) {
        store.send(.detailPlant(plant), animation: nil)
    }
    
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        let result: CGPoint
        let y = y + CGFloat(plant.pot.height) + CGFloat(plant.seed.height)
        let deltaX = [plant.pot.width, plant.seed.width].max()! / 2
        
        defer {
            store.send(.movePlant(plant, result))
        }
        
        let shelfs = store.state.shelfType.shelfPositions.sorted { $0.coefOffsetY < $1.coefOffsetY }
        
        for shelf in shelfs {
            if shelf.coefOffsetY * height >= y {
                if x + deltaX >= shelf.paddingLeading  && x + deltaX <= roomViewWidth - shelf.paddingTrailing {
                    result = CGPoint(x: x, y: shelf.coefOffsetY * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
                    return result
                }
            }
        }
        
        result = CGPoint(x: x, y: (shelfs.last?.coefOffsetY ?? 1) * height - CGFloat(plant.pot.height) - CGFloat(plant.seed.height))
        return result
    }
    
    func beganToChangePosition() {
        store.send(.startMovePlant)
    }
}

//#Preview {
//    ShelfView()
//}

#Preview {
    VStack {
        screenBuilderMock.getComponent(type: .roomView(id: nil))
        Spacer()
    }.ignoresSafeArea()
}

//#Preview {
//    screenBuilderMock.getScreen(type: .home)
//}

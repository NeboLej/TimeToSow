//
//  ShelfView.swift
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

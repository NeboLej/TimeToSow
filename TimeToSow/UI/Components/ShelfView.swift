//
//  ShelfView.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

struct PlantView: View {
    
    @State var plant: Plant
    
    @State private var accumulated: CGFloat
    @State var isEdit: Bool = false
    @Binding var isCanEdit: Bool
    @State var offsetX: CGFloat
    
    init(plant: Plant, isCanEdit: Binding<Bool>) {
        self.plant = plant
        self._isCanEdit = isCanEdit
        self.accumulated = plant.offsetX
        self.offsetX = plant.offsetX
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
        .offset(x: offsetX)
        .gesture(DragGesture()
            .onChanged{ value in
                if isCanEdit {
                    offsetX = value.translation.width + self.accumulated
                }
            }
            .onEnded{ value in
                if isCanEdit {
                    self.accumulated = offsetX
//                    vm.endMove()
                }
            })
    }
}

struct ShelfView: View {
    
    @State var shelf: Shelf
    @State var height: CGFloat = 400
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(shelf.type.image)
                .resizable()
            
            ForEach(shelf.type.shelfPositions,  id: \.self) {
                Rectangle()
                    .fill(.red)
                    .frame(height: 12)
                    .offset(y: $0.coefOffsetY * height)
                    .padding(.leading, $0.paddingLeading)
                    .padding(.trailing, $0.paddingTrailing)
                    .opacity(0.1)
            }
            plants()
            
        }
        .frame(height: height)
        
        
    }
    
    @ViewBuilder
    func plants() -> some View {
        ForEach(shelf.plants, id: \.self) {
            PlantView(plant: $0, isCanEdit: .constant(true))
                .offset(y: getOffsetY(line: $0.line) - CGFloat($0.pot.width) - CGFloat($0.seed.width) + 1)
        }
    }
    
//    @ViewBuilder
//    func plant(plant: Plant) -> some View {
//        VStack(alignment: .center, spacing: 0) {
//            Image(plant.seed.image)
//                .resizable()
//                .scaledToFit()
//                .frame(height: CGFloat(plant.seed.width))
//            Image(plant.pot.image)
//                .resizable()
//                .scaledToFit()
//                .frame(height: CGFloat(plant.pot.width))
//        }
//        .offset(x: plant.offsetX, y: getOffsetY(line: plant.line) - CGFloat(plant.pot.width) - CGFloat(plant.seed.width) + 1)
//    }
    
    func getOffsetY(line: Int) -> CGFloat {
        shelf.type.shelfPositions[line].coefOffsetY * height
    }

}

//#Preview {
//    ShelfView()
//}

#Preview {
    HomeScreen()
}

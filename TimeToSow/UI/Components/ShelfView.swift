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
    
    @State private var accumulated: CGFloat
    @State var offsetX: CGFloat
    @State var isEdit: Bool = false
    @Binding var isCanEdit: Bool
    @State var lastXYPosisitions: EdgeInsets
    
    
    init(plant: Plant, lastXYPosisitions: EdgeInsets, isCanEdit: Binding<Bool>) {
        self.plant = plant
        self._isCanEdit = isCanEdit
        self.accumulated = plant.offsetX
        self.offsetX = plant.offsetX
        self.lastXYPosisitions = lastXYPosisitions
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
                    let newOffsetX = value.translation.width + self.accumulated
                    if newOffsetX < lastXYPosisitions.leading {
                        offsetX = lastXYPosisitions.leading
                    } else if newOffsetX > lastXYPosisitions.trailing {
                        offsetX = lastXYPosisitions.trailing
                    } else {
                        offsetX = newOffsetX
                    }
                    print(offsetX)
                }
            }
            .onEnded { value in
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
    @State var width: CGFloat = 400
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
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
                plants(widthView: proxy.size.width)
            }
            
        }
        .frame(height: height)
        
    }
    
    @ViewBuilder
    func plants(widthView: CGFloat) -> some View {
        ForEach(shelf.plants, id: \.self) {
            PlantView(plant: $0,
                      lastXYPosisitions: EdgeInsets(top: 0,
                                                    leading: getLeadingOffsetX(line: $0.line),
                                                    bottom: 0,
                                                    trailing: getTrailingOffsetX(plant: $0, widthView: widthView)),
                      isCanEdit: .constant(true))
                .offset(y: getOffsetY(line: $0.line) - CGFloat($0.pot.width) - CGFloat($0.seed.width) + 1)
        }
    }
    
    
    func getOffsetY(line: Int) -> CGFloat {
        shelf.type.shelfPositions[line].coefOffsetY * height
    }
    
    func getLeadingOffsetX(line: Int) -> CGFloat {
        shelf.type.shelfPositions[line].paddingLeading
    }
    
    func getTrailingOffsetX(plant: Plant, widthView: CGFloat) -> CGFloat {
        widthView - shelf.type.shelfPositions[plant.line].paddingTrailing - CGFloat(plant.pot.width)
    }
    
}

//#Preview {
//    ShelfView()
//}

#Preview {
    HomeScreen()
}

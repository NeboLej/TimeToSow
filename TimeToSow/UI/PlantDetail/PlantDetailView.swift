//
//  PlantDetailView.swift
//  TimeToSow
//
//  Created by Nebo on 21.12.2025.
//

import SwiftUI

struct PlantDetailView: View {

    let plant: Plant
    
    var body: some View {
        VStack {
            headerView()
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    PlantPreview(zoomCoef: 2.5, plant: plant)
//                    Spacer()
                }.padding()
            }
           
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .center) {
            Text(plant.seed.name)
                .foregroundStyle(.black)
                .font(.myTitle(24))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
        .background(.red)
    }
}

extension PlantDetailView: PositionPlantDelegate  {
    var roomViewWidth: CGFloat { 0 }
    
    func getPositionOfPlantInFall(plant: Plant, x: CGFloat, y: CGFloat) -> CGPoint {
        .zero
    }
    
    func beganToChangePosition() {}
    
    func selectPlant(_ plant: Plant) {}
    
    func detailPlant(_ plant: Plant) {}
    
    
}


//#Preview {
//    screenBuilderMock.getScreen(type: .home)
//}

#Preview {
    PlantDetailView(plant: Plant(seed: Seed(name: "Oleg",
                                            availavlePotTypes: [.large, .medium],
                                            image: "seed23",
                                            height: 45,
                                            startTimeInterval: 10,
                                            endTimeInterval: 100),
                                 pot: Pot(potType: .large,
                                          name: "potOleg",
                                          image: "pot21",
                                          height: 24),
                                 tag: Tag(name: "bebebe",
                                          color: ""),
                                 offsetX: 200,
                                 offsetY: 200,
                                 time: 200))
}

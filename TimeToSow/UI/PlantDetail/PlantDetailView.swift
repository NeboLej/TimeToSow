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
        VStack(spacing: 0) {
            headerView()
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Palm tree\nand cute wicker pot")
                        .font(.myTitle(20))
                        .foregroundStyle(.black)
                        .padding(.all, 10)
                    
                    HStack(alignment: .top) {
                        statisticsView()
                        Spacer()
                        PlantPreview(zoomCoef: plant.seed.height + plant.pot.height > 100 ? 1.5 : 2.5,
                                     plant: plant,
                                     isShowPlantRating: true,
                                     isShowPotRating: true)
                            .padding(.trailing, 14)
                            .padding(.vertical, 20)
                    }
                    
                    Text("Description")
                        .font(.myTitle(20))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                    
                    Text("I wrote some description for this plant. The user simply has this option, but they don't have to.")
                        .font(.myDescription(14))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }.background(.mainBackground)
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
    
    @ViewBuilder
    private func statisticsView() -> some View {
        TextureView(insets: .init(top: 6, leading: 15, bottom: 6, trailing: 15),
                    texture: Image(.smallTexture1), cornerRadius: 12) {
            DrawText(text: plant.time.toHoursAndMinutes(),
                     font: UIFont.myTitle(18),
                     duration: 1)
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }
    
}


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

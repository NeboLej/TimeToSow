//
//  PlantPreview.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

struct PlantPreview: View {
    
    @State var zoomCoef: CGFloat = 2.5
    @State var plant: Plant
    var isShowPlantRating: Bool = true
    var isShowPotRating: Bool = true
    
    private var centerX: CGFloat {
        (max(CGFloat(plant.seed.width), CGFloat(plant.pot.width)) / 2) * zoomCoef
    }
    
    var body: some View {
        selectedPlantPreview()
    }
    
    @ViewBuilder
    private func selectedPlantPreview() -> some View {
        
        let offetX = ((plant.seed.rootCoordinateCoef?.x ?? 0) * CGFloat(plant.seed.height)
                      + (plant.pot.anchorPointCoefficient?.x ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        
        let offsetY = ((plant.seed.rootCoordinateCoef?.y ?? 0) * CGFloat(plant.seed.height)
                       + (plant.pot.anchorPointCoefficient?.y ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .center, spacing: 0) {
                
                Image(plant.seed.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: CGFloat(plant.seed.height) * zoomCoef)
                    .offset(x: offetX, y: offsetY)
                    .zIndex(2)
                
                Image(plant.pot.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: CGFloat(plant.pot.height) * zoomCoef)
            }
            
            
            if isShowPlantRating {
                plantRating(rating: plant.seed.rarity.starCount)
                    .zIndex(2)
            }
            
            if isShowPotRating {
                potRating(rating: plant.pot.rarity.starCount)
            }
        }.offset(x: -offetX, y: -offsetY)
    }
    
    @ViewBuilder
    func plantRating(rating: Int) -> some View {
        let rootCoordinateCoefY = plant.seed.rootCoordinateCoef?.y ?? 0
        
        HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                RarityView(count: rating)
                    .padding(.horizontal, 4)
                    .frame(height: 12)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.black)
                            .offset(y: 2)
                    }
            }
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(width: centerX, height: 1)
                    .foregroundStyle(.black)
                    .offset(y: 2)
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .frame(width: 6, height: 6)
                    .offset(y: 4)
            }
            .rotationEffect(.degrees(35), anchor: .leading)
            .offset(x: 2, y: 1)
            
        }.offset(x: -centerX,
                 y: -(CGFloat(plant.pot.height) + CGFloat(plant.seed.height)) * zoomCoef +
                 CGFloat(plant.seed.height) * zoomCoef * rootCoordinateCoefY - 10)
    }
    
    @ViewBuilder
    func potRating(rating: Int) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                RarityView(count: rating)
                    .padding(.horizontal, 4)
                    .frame(height: 12)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.black)
                            .offset(y: 2)
                    }
            }
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(width: centerX, height: 1)
                    .foregroundStyle(.black)
                    .offset(y: 2)
                Circle()
                    .stroke(.black, lineWidth: 1)
                    .frame(width: 6, height: 6)
                    .offset(y: 4)
            }
            .rotationEffect(.degrees(-35), anchor: .leading)
            .offset(x: -3, y: 1)
        }
        .offset(x: -centerX,
                y: 10)
    }
}

#Preview {
    let seed1 = Seed(name: "qwe",
                     availavlePotTypes: PotType.allCases,
                     image: "seed26",
                     height: 90,
                     rarity: .uncommon,
                     rootCoordinateCoef: .init(x: 0, y: 0.93))
    
    let seed2 = Seed(name: "qwe",
                     availavlePotTypes: PotType.allCases,
                     image: "seed25",
                     height: 30,
                     rarity: .rare,
                     rootCoordinateCoef: .init(x: 0.1, y: 0))
    
    var tmpSeed = Seed(name: "qwe",
                       availavlePotTypes: PotType.allCases,
                       image: "seed33",
                       height: 40,
                       rarity: .common,
                       rootCoordinateCoef: .init(x: 0.1,
                                                 y: 0.19))

    var tmpPot = Pot(potType: .small,
                     name: "aeded",
                     image: "pot24",
                     height: 22,
                     rarity: .common)
    VStack {
        PlantPreview(plant: Plant(seed: tmpSeed,
                                  pot: tmpPot,
                                  name: "test",
                                  description: "",
                                  offsetY: 200,
                                  offsetX: 200,
                                 notes: []))
        Spacer()
    }
    

}




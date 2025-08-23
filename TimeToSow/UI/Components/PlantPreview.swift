//
//  PlantPreview.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

struct PlantPreview: View {
    
    @State var zoomCoef: CGFloat = 2.0
    @State var plant: Plant
    
    var body: some View {
        selectedPlantPreview()
    }
    
   
    @ViewBuilder
    private func selectedPlantPreview() -> some View {
        
        let offetX = ((plant.seed.rootCoordinateCoef?.x ?? 0) * CGFloat(plant.seed.height)
                      + (plant.pot.anchorPointCoefficient?.x ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        let offsetY = ((plant.seed.rootCoordinateCoef?.y ?? 0) * CGFloat(plant.seed.height)
                       + (plant.pot.anchorPointCoefficient?.y ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        
        VStack(alignment: .center, spacing: 0) {
            Image(plant.seed.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.seed.height) * zoomCoef)
                .offset(x: offetX,
                        y: offsetY)
                .zIndex(10)
            Image(plant.pot.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.pot.height) * zoomCoef)
        }
        .offset(x: 0, y: -offsetY/1.3)
    }
}

//
//  PlantViewState.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

struct PlantViewState: Identifiable {
    let id: UUID
    let seed: Seed
    let pot: Pot
    let tag: Tag
    
    let offsetY: Double
    let offsetX: Double
    
    let isSelected: Bool
    let original: Plant
    
    init(plant: Plant, isSelected: Bool) {
        original = plant
        id = plant.id
        seed = plant.seed
        pot = plant.pot
        tag = plant.tag
        offsetY = plant.offsetY
        offsetX = plant.offsetX
        
        self.isSelected = isSelected
    }
}

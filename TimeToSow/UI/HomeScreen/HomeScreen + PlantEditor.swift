//
//  HomeScreen + PlantEditor.swift
//  TimeToSow
//
//  Created by Nebo on 30.06.2025.
//

import Foundation

extension HomeScreen: PlantEditorDelegate {
    
    func editPisitionPlant(plant: Plant, newPosition: CGPoint) {
        appStore.changePlant(plant: plant.copy(offsetX: newPosition.x, offsetY: newPosition.y))
    }
}

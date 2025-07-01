//
//  HomeScreen + PlantEditor.swift
//  TimeToSow
//
//  Created by Nebo on 30.06.2025.
//

import Foundation
import SwiftUI

extension HomeScreen: PlantEditorDelegate {
    
    func beganToChangePosition() {
        withAnimation {
            isMovePlant = true
        }
    }
    
    func editPositionPlant(plant: Plant, newPosition: CGPoint) {
        withAnimation {
            isMovePlant = false
        }
        
        appStore.updatePlant(with: plant.copy(offsetX: newPosition.x, offsetY: newPosition.y))
    }
    
    func positionFixedOutsideTheRoom(plant: Plant, newPosition: CGPoint) {
        print(plant.id)
        print(newPosition)
        print(targetFrame)
        
         isInTargetZone = targetFrame.contains(newPosition)
        
        if isInTargetZone {
            selectedPlant = plant
        } else {
            selectedPlant = nil
        }
        
        print(isInTargetZone)
    }
}

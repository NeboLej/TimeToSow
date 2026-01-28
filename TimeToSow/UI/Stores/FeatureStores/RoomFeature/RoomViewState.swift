//
//  RoomViewState.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

struct RoomViewState {
    let roomType: RoomType
    
    let shelfType: ShelfType
    let plants: [PlantViewState]
    let decor: [Decor]
    
    init(userRoom: UserRoom, selectedPlant: Plant?) {
        roomType = userRoom.roomType
        shelfType = userRoom.shelfType
        plants = userRoom.plants.values.filter { $0.isOnShelf }.map { PlantViewState(plant: $0, isSelected: $0 == selectedPlant) }
        decor = userRoom.decor.values.map { $0 }
    }
}

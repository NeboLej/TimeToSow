//
//  HomeScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import Foundation

struct HomeScreenState {
    let shelf: ShelfType
    let room: RoomType
    
    let selectedPlant: Plant?
    
    init(appStore: AppStore) {
        shelf = appStore.currentRoom.shelfType
        room = appStore.currentRoom.roomType
        
        selectedPlant = appStore.selectedPlant
    }
}

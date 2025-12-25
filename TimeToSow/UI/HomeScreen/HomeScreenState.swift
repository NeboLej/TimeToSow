//
//  HomeScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import SwiftUI

struct HomeScreenState {
    let shelf: ShelfType
    let room: RoomType
    let headerColor: Color
    let plantCount: Int
    let loggedMinutesCount: Int
    let allNotes: [Note]
    
    let selectedPlant: Plant?
    
    init(appStore: AppStore) {
        shelf = appStore.currentRoom.shelfType
        room = appStore.currentRoom.roomType
        headerColor = Color.averageTopRowColor(from: UIImage(named: room.image))
        plantCount = appStore.currentRoom.plants.count
        loggedMinutesCount = appStore.currentRoom.plants.reduce(0) { $0 + $1.value.time }
        allNotes = appStore.currentRoom.plants.flatMap(\.value.notes)
        
        selectedPlant = appStore.selectedPlant
    }
}

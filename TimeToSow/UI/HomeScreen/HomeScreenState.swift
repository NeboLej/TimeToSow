//
//  HomeScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import SwiftUI

struct HomeScreenState {
    let roomName: String
    let shelf: ShelfType
    let room: RoomType
    let headerColor: Color
    let plantCount: Int
    let loggedMinutesCount: Int
    let allNotes: [Note]
    
    let selectedPlant: Plant?
    let selectedTag: Tag?
    let topPlant: Plant?
    let topTag: Tag?
    let boxPlants: [Plant]
    let boxDecor: [Decor]
    
    init(appStore: AppStore) {
        roomName = appStore.currentRoom.name
        shelf = appStore.currentRoom.shelfType
        room = appStore.currentRoom.roomType
        headerColor = Color.averageTopRowColor(from: UIImage(named: room.image))
        plantCount = appStore.currentRoom.plants.count
        loggedMinutesCount = appStore.currentRoom.plants.reduce(0) { $0 + $1.value.time }
        allNotes = appStore.currentRoom.plants.flatMap(\.value.notes)
        
        selectedPlant = appStore.selectedPlant
        topPlant = appStore.currentRoom.plants.map { $0.value }.max(by: { $0.time < $1.time })
        
        let dict = allNotes.reduce(into: [:]) { result, note in
            result[note.tag, default: 0] += note.time
        }
        topTag = dict.map { ($0.key, $0.value) }.max(by: { $0.1 > $1.1 })?.0
        selectedTag = appStore.selectedTag
        boxPlants = appStore.currentRoom.plants.map { $0.value }
        
        let tmpRewardDecor1: Decor = Decor(id: UUID(), name: "Лошадка", locationType: .stand,
                                          animationOptions: AnimationOptions(duration: 1, repeatCount: 2, timeRepetition: 30),
                                          resourceName: "decor1", positon: .zero, height: 40)
        
        let tmpRewardDecor2: Decor = Decor(id: UUID(), name: "Часики", locationType: .free,
                                          animationOptions: nil,
                                          resourceName: "decor2", positon: .zero, height: 40)
        
        let tmpRewardDecor3: Decor = Decor(id: UUID(), name: "Колокольчик", locationType: .hand,
                                                   animationOptions: nil,
                                                   resourceName: "decor3", positon: .zero, height: 40)
        
        boxDecor = [tmpRewardDecor1, tmpRewardDecor2, tmpRewardDecor3]
    }
}

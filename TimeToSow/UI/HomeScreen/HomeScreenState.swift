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
    let bonusCount: Int
    let loggedMinutesCount: Int
    let allNotes: [Note]
    
    let selectedPlant: Plant?
    let selectedTag: Tag?
    let topPlant: Plant?
    let topTag: Tag?
    
    init(appStore: AppStore) {
        let plants = appStore.currentRoom.plants
        roomName = appStore.currentRoom.name
        shelf = appStore.currentRoom.shelfType
        room = appStore.currentRoom.roomType
        headerColor = Color.averageTopRowColor(from: UIImage(named: room.image))
        plantCount = appStore.currentRoom.plants.count
        loggedMinutesCount = plants.reduce(0) { $0 + $1.value.time }
        allNotes = plants.flatMap(\.value.notes)
        
        selectedPlant = appStore.selectedPlant
        topPlant = plants.map { $0.value }.max(by: { $0.time < $1.time })
        
        let dict = allNotes.reduce(into: [:]) { result, note in
            result[note.tag, default: 0] += note.time
        }
        topTag = dict.map { ($0.key, $0.value) }.max(by: { $0.1 > $1.1 })?.0
        selectedTag = appStore.selectedTag
        bonusCount = appStore.currentRoom.decor.count
    }
}


let tmpRewardDecor1 = Decor(decorType: DecorType(id: UUID(),
                                                 name: "Лошадка",
                                                 locationType: .stand,
                                                 animationOptions: AnimationOptions(duration: 1, repeatCount: 2, timeRepetition: 30),
                                                 resourceName: "decor1",
                                                 height: 40,
                                                 isUnlocked: false),
                             rootRoomID: UUID(),
                             offsetY: .zero,
                             offsetX: .zero)

let tmpRewardDecor2 = Decor(decorType: DecorType(id: UUID(),
                                                 name: "Часики",
                                                 locationType: .free,
                                                 animationOptions: nil,
                                                 resourceName: "decor2",
                                                 height: 40,
                                                 isUnlocked: false),
                             rootRoomID: UUID(),
                             offsetY: .zero,
                             offsetX: .zero)

let tmpRewardDecor3 = Decor(decorType: DecorType(id: UUID(),
                                                 name: "Колокольчик",
                                                 locationType: .hand,
                                                 animationOptions: nil,
                                                 resourceName: "decor3",
                                                 height: 40,
                                                 isUnlocked: false),
                             rootRoomID: UUID(),
                             offsetY: .zero,
                             offsetX: .zero)

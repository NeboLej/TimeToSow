//
//  HistoryScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import SwiftUI

struct HistoryScreenState {
    let name: String
    let notes: [Note]
    let monthsName: [String] = ["One", "Two", "Three", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve"]
    let plantCount = 12
    let loggedMinutesCount = 230
    let topPlant: Plant? = Plant(rootRoomID: UUID(), seed: tmpSeed, pot: tmpPot, name: "", description: "", offsetY: 0, offsetX: 0, notes: [])
    let topTag: Tag? = Tag(name: "asdad", color: "FFDD55")
    let headerColor: Color
    let isCurrentMonth: Bool = true
    
    init(appStore: AppStore) {
        name = appStore.currentRoom.name
        headerColor = Color.averageTopRowColor(from: UIImage(named: appStore.currentRoom.roomType.image))
        notes = appStore.currentRoom.plants.flatMap { $0.value.notes }
    }
}

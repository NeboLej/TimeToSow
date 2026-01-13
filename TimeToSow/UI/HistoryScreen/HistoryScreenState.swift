//
//  HistoryScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import SwiftUI

struct HistoryScreenState: Equatable {
    let currentRoomId: UUID
    let name: String
    let notes: [Note]
    let allRooms: [SimpleUserRoom] //= ["One", "Two", "Three", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve"]
    let plantCount: Int //= 12
    let loggedMinutesCount: Int //= 230
    let topPlant: Plant? //= Plant(rootRoomID: UUID(), seed: tmpSeed, pot: tmpPot, name: "", description: "", offsetY: 0, offsetX: 0, notes: [])
    let topTag: Tag? = Tag(stableId: "", name: "asdad", color: "FFDD55")
    let headerColor: Color
    let isCurrentMonth: Bool// = true
    
    init(selectedRoomId: UUID, appStore: AppStore) {
        guard let selectedRoom = appStore.userRooms[selectedRoomId] else { fatalError() }
        currentRoomId = selectedRoomId
        name = selectedRoom.name
        notes = selectedRoom.plants.flatMap { $0.value.notes }
        allRooms = appStore.simpleUserRooms
        plantCount = selectedRoom.plants.count
        let plantsAttay = selectedRoom.plants.map(\.value)
        
        loggedMinutesCount = plantsAttay.reduce(0, {  $1.time + $0 })
        topPlant = plantsAttay.max(by: { $0.time < $1.time })
        headerColor = Color.averageTopRowColor(from: UIImage(named: selectedRoom.roomType.image))
        isCurrentMonth = selectedRoomId == appStore.currentRoom.id
    }
    
    private var monthColors = ["218B82", "F7CE76", "C54E6C", "9AD9DB", "EF874D", "A15D98"].map { Color(hex: $0) }
    
    func getMonthColor(by id: UUID) -> Color {
        guard let firstIndex = allRooms.firstIndex(where: { $0.id == id }) else { return .orange }
        return monthColors[firstIndex % monthColors.count]
    }
}

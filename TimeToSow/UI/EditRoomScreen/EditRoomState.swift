//
//  EditRoomState.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import Foundation

struct EditRoomState {
    let selectedRoom: RoomType
    let selectedShelf: ShelfType
    
    let allShelfs: [ShelfType]
    let allRooms: [RoomType]
    
    init(selectedRoom: RoomType, selectedShelf: ShelfType, allRooms: [RoomType], allShelfs: [ShelfType]) {
        self.selectedRoom = selectedRoom
        self.selectedShelf = selectedShelf
        self.allRooms = allRooms
        self.allShelfs = allShelfs
    }
}

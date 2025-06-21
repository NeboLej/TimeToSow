//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct UserMonthRoom: Hashable {
    let id: UUID
    let shelfType: ShelfType
    let roomType: RoomType
    let name: String
    let dateCreate: Date
    let plants: [Plant]
    
    init(id: UUID = UUID.init(), shelfType: ShelfType, roomType: RoomType, name: String, dateCreate: Date, plants: [Plant]) {
        self.id = id
        self.shelfType = shelfType
        self.roomType = roomType
        self.name = name
        self.dateCreate = dateCreate
        self.plants = plants
    }
    
    func copy(id: UUID = UUID.init(), shelfType: ShelfType? = nil, roomType: RoomType? = nil, name: String? = nil, plants: [Plant]? = nil) -> UserMonthRoom {
        UserMonthRoom(id: self.id, shelfType: shelfType ?? self.shelfType,
                      roomType: roomType ?? self.roomType, name: name ?? self.name,
                      dateCreate: self.dateCreate, plants: plants ?? self.plants)
    }
    
    static var empty = UserMonthRoom(shelfType: .init(name: "", image: "", shelfPositions: []), roomType: .init(name: "", image: ""), name: "", dateCreate: Date(), plants: [])
}

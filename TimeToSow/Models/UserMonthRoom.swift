//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

@Observable
class UserMonthRoom: Hashable {
    
    static func == (lhs: UserMonthRoom, rhs: UserMonthRoom) -> Bool {
        lhs.id == rhs.id &&
        lhs.plants == rhs.plants &&
        lhs.shelfType == rhs.shelfType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(shelfType)
        hasher.combine(plants)
    }
    
    var id: UUID
    var shelfType: ShelfType
    var roomType: RoomType
    var name: String
    var dateCreate: Date
    var plants: [String: Plant]
    
    init(id: UUID = UUID.init(), shelfType: ShelfType, roomType: RoomType, name: String, dateCreate: Date, plants: [String: Plant]) {
        self.id = id
        self.shelfType = shelfType
        self.roomType = roomType
        self.name = name
        self.dateCreate = dateCreate
        self.plants = plants
    }
    
    func copy(shelfType: ShelfType? = nil, roomType: RoomType? = nil, name: String? = nil, plants: [String: Plant]? = nil) -> UserMonthRoom {
        UserMonthRoom(id: self.id, shelfType: shelfType ?? self.shelfType,
                      roomType: roomType ?? self.roomType, name: name ?? self.name,
                      dateCreate: self.dateCreate, plants: plants ?? self.plants)
    }
    
    static var empty = UserMonthRoom(shelfType: .init(name: "", image: "", shelfPositions: []), roomType: .init(name: "", image: ""), name: "", dateCreate: Date(), plants: [:])
}
